// Package vecgo provides functionalities for an embedded vector store database.
package vecgo

import (
	"container/heap"
	"encoding/gob"
	"errors"
	"fmt"
	"io"
	"os"
	"runtime"
	"sync"

	"github.com/hupe1980/vecgo/hnsw"
	"golang.org/x/sync/errgroup"
)

var (
	// ErrNotFound is returned when an item is not found.
	ErrNotFound = errors.New("not found")

	// ErrInvalidEFValue is returned when the Explore Factor (EF) is less than the value of k.
	ErrInvalidEFValue = errors.New("Explore Factor (EF) must be at least the value of k")
)

// Options contains configuration options for Vecgo.
type Options struct {
	HNSW hnsw.Options
}

// Vecgo is a vector store database.
type Vecgo[T any] struct {
	index *hnsw.HNSW
	store map[uint32]T
	mutex sync.Mutex
}

// New creates a new Vecgo instance with the given dimension and options.
func New[T any](dimension int, optFns ...func(o *Options)) *Vecgo[T] {
	opts := Options{
		HNSW: hnsw.DefaultOptions,
	}

	for _, fn := range optFns {
		fn(&opts)
	}

	return &Vecgo[T]{
		index: hnsw.New(dimension, func(o *hnsw.Options) {
			*o = opts.HNSW
		}),
		store: make(map[uint32]T),
	}
}

// NewFromFilename creates a new Vecgo instance from a file.
func NewFromFilename[T any](filename string) (*Vecgo[T], error) {
	file, err := os.Open(filename)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	return NewFromReader[T](file)
}

// NewFromReader creates a new Vecgo instance from an io.Reader.
func NewFromReader[T any](r io.Reader) (*Vecgo[T], error) {
	decoder := gob.NewDecoder(r)

	vg := &Vecgo[T]{}

	// Decode the index
	if err := decoder.Decode(&vg.index); err != nil {
		return nil, err
	}

	// Decode the store
	if err := decoder.Decode(&vg.store); err != nil {
		return nil, err
	}

	return vg, nil
}

// Get retrieves an item by ID.
func (vg *Vecgo[T]) Get(id uint32) (T, error) {
	data, ok := vg.store[id]
	if !ok {
		return data, ErrNotFound
	}

	return data, nil
}

// VectorWithData represents a vector along with associated data.
type VectorWithData[T any] struct {
	Vector []float32
	Data   T
}

// Insert inserts a vector along with associated data into the database.
func (vg *Vecgo[T]) Insert(item *VectorWithData[T]) (uint32, error) {
	id, err := vg.index.Insert(item.Vector)
	if err != nil {
		return 0, err
	}

	vg.mutex.Lock()
	defer vg.mutex.Unlock()

	vg.store[id] = item.Data

	return id, nil
}

// BatchInsert inserts multiple elements into the Vecgo index concurrently.
func (vg *Vecgo[T]) BatchInsert(items []*VectorWithData[T]) ([]uint32, error) {
	// Create an error group to manage multiple goroutines
	eg := errgroup.Group{}

	eg.SetLimit(runtime.NumCPU())

	// Create a channel to receive IDs of inserted items
	idCh := make(chan uint32, len(items))

	// Function to insert a single item and signal completion to the error group
	insertItem := func(item *VectorWithData[T]) error {
		id, err := vg.Insert(item)
		if err != nil {
			return fmt.Errorf("error inserting item: %w", err)
		}

		idCh <- id
		return nil
	}

	// Launch a goroutine for each item to insert them concurrently
	for _, item := range items {
		item := item // Capture range variable
		eg.Go(func() error {
			return insertItem(item)
		})
	}

	// Close the ID channel after all goroutines have completed
	go func() {
		_ = eg.Wait()
		close(idCh)
	}()

	// Preallocate the ids slice with the length of items
	ids := make([]uint32, 0, len(items))

	// Collect inserted item IDs from the channel
	for id := range idCh {
		ids = append(ids, id)
	}

	if err := eg.Wait(); err != nil {
		return nil, err
	}

	return ids, nil
}

// SearchResult represents a search result.
type SearchResult[T any] struct {
	ID       uint32
	Distance float32
	Data     T
}

// KNNSearchOptions contains options for KNN search.
type KNNSearchOptions struct {
	// EF (Explore Factor) specifies the size of the dynamic list for the nearest neighbors during the search.
	// Higher EF leads to more accurate but slower search.
	// EF cannot be set lower than the number of queried nearest neighbors (k).
	// The value of EF can be anything between k and the size of the dataset.
	EF int
}

// KNNSearch performs a K-nearest neighbor search.
func (vg *Vecgo[T]) KNNSearch(query []float32, k int, optFns ...func(o *KNNSearchOptions)) ([]SearchResult[T], error) {
	opts := KNNSearchOptions{
		EF: 50,
	}

	for _, fn := range optFns {
		fn(&opts)
	}

	if opts.EF < k {
		return nil, ErrInvalidEFValue
	}

	bestCandidates, err := vg.index.KNNSearch(query, k, opts.EF)
	if err != nil {
		return nil, err
	}

	return vg.extractSearchResults(bestCandidates)
}

// BruteSearch performs a brute-force search.
func (vg *Vecgo[T]) BruteSearch(query []float32, k int) ([]SearchResult[T], error) {
	bestCandidates, err := vg.index.BruteSearch(query, k)
	if err != nil {
		return nil, err
	}

	return vg.extractSearchResults(bestCandidates)
}

// extractSearchResults extracts search results from a priority queue.
func (vg *Vecgo[T]) extractSearchResults(bestCandidates *hnsw.PriorityQueue) ([]SearchResult[T], error) {
	result := make([]SearchResult[T], 0, bestCandidates.Len())

	for i := 0; i < bestCandidates.Len(); i++ {
		item := heap.Pop(bestCandidates).(*hnsw.PriorityQueueItem)
		if item.Node != 0 {
			result = append(result, SearchResult[T]{
				ID:       item.Node,
				Distance: item.Distance,
				Data:     vg.store[item.Node],
			})
		}
	}

	return result, nil
}

// SaveToWriter saves the Vecgo database to an io.Writer.
func (vg *Vecgo[T]) SaveToWriter(w io.Writer) error {
	encoder := gob.NewEncoder(w)

	// Encode the index
	if err := encoder.Encode(vg.index); err != nil {
		return err
	}

	// Encode the store
	if err := encoder.Encode(vg.store); err != nil {
		return err
	}

	return nil
}

// SaveToFile saves the Vecgo database to a file.
func (vg *Vecgo[T]) SaveToFile(filename string) error {
	file, err := os.Create(filename)
	if err != nil {
		return err
	}
	defer file.Close()

	return vg.SaveToWriter(file)
}

// PrintStats prints statistics about the database.
func (vg *Vecgo[T]) PrintStats() {
	vg.index.Stats()
}
