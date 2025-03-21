// Package vecgo provides functionalities for an embedded vector store database.
package vecgo

import (
	"encoding/gob"
	"errors"
	"fmt"
	"io"
	"os"
	"sync"

	"github.com/ylerby/vecgo/index"
	"github.com/ylerby/vecgo/index/flat"
	"github.com/ylerby/vecgo/index/hnsw"
)

var (
	// ErrNotFound is returned when an item is not found.
	ErrNotFound = errors.New("not found")

	// ErrInvalidEFValue is returned when the explore factor (ef) is less than the value of k.
	ErrInvalidEFValue = errors.New("explore factor (ef) must be at least the value of k")
)

// Vecgo is a vector store database.
type Vecgo[T any] struct {
	index index.Index
	store map[uint32]T
	mutex sync.Mutex
}

// NewFlat creates a new Vecgo instance with a flat index.
func NewFlat[T any](optFns ...func(o *flat.Options)) *Vecgo[T] {
	opts := flat.DefaultOptions

	for _, fn := range optFns {
		fn(&opts)
	}

	i := flat.New(func(o *flat.Options) {
		*o = opts
	})

	return New[T](i)
}

// NewHNSW creates a new Vecgo instance with an HNSW index.
func NewHNSW[T any](optFns ...func(o *hnsw.Options)) *Vecgo[T] {
	opts := hnsw.DefaultOptions

	for _, fn := range optFns {
		fn(&opts)
	}

	i := hnsw.New(func(o *hnsw.Options) {
		*o = opts
	})

	return New[T](i)
}

// New creates a new Vecgo instance with the given index.
func New[T any](i index.Index) *Vecgo[T] {
	return &Vecgo[T]{
		index: i,
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

	newIndex := hnsw.New()

	// Decode the index
	if err := decoder.Decode(newIndex); err != nil {
		return nil, err
	}

	vg.index = newIndex

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
func (vg *Vecgo[T]) Insert(item VectorWithData[T]) (uint32, error) {
	id, err := vg.index.Insert(item.Vector)
	if err != nil {
		return 0, err
	}

	vg.mutex.Lock()
	defer vg.mutex.Unlock()

	vg.store[id] = item.Data

	return id, nil
}

// SearchResult represents a search result.
type SearchResult[T any] struct {
	index.SearchResult
	// ID is the identifier of the search result.
	//ID uint32

	// Distance is the distance between the query vector and the result vector.
	//Distance float32

	// Data is the associated data of the search result.
	Data T
}

// FilterFunc is a function type used for filtering search results.
type FilterFunc func(id uint32) bool

// KNNSearchOptions contains options for KNN search.
type KNNSearchOptions struct {
	// EF (Explore Factor) specifies the size of the dynamic list for the nearest neighbors during the search.
	// Higher EF leads to more accurate but slower search.
	// EF cannot be set lower than the number of queried nearest neighbors (k).
	// The value of EF can be anything between k and the size of the dataset.
	EF int

	// FilterFunc is a function used to filter search results.
	FilterFunc FilterFunc
}

// KNNSearch performs a K-nearest neighbor search.
func (vg *Vecgo[T]) KNNSearch(query []float32, k int, optFns ...func(o *KNNSearchOptions)) ([]SearchResult[T], error) {
	opts := KNNSearchOptions{
		EF:         50,
		FilterFunc: func(id uint32) bool { return true },
	}

	for _, fn := range optFns {
		fn(&opts)
	}

	if opts.EF < k {
		return nil, ErrInvalidEFValue
	}

	bestCandidates, err := vg.index.KNNSearch(query, k, opts.EF, func(id uint32) bool {
		return opts.FilterFunc(id)
	})
	if err != nil {
		return nil, err
	}

	return vg.extractSearchResults(bestCandidates), nil
}

// BruteSearchOptions contains options for brute-force search.
type BruteSearchOptions struct {
	// FilterFunc is a function used to filter search results.
	FilterFunc FilterFunc
}

// BruteSearch performs a brute-force search.
func (vg *Vecgo[T]) BruteSearch(query []float32, k int, optFns ...func(o *BruteSearchOptions)) ([]SearchResult[T], error) {
	opts := BruteSearchOptions{
		FilterFunc: func(id uint32) bool { return true },
	}

	for _, fn := range optFns {
		fn(&opts)
	}

	bestCandidates, err := vg.index.BruteSearch(query, k, func(id uint32) bool {
		return opts.FilterFunc(id)
	})
	if err != nil {
		return nil, err
	}

	return vg.extractSearchResults(bestCandidates), nil
}

// extractSearchResults extracts search results from a priority queue.
func (vg *Vecgo[T]) extractSearchResults(bestCandidates []index.SearchResult) []SearchResult[T] {
	result := make([]SearchResult[T], 0, len(bestCandidates))

	for _, item := range bestCandidates {
		result = append(result, SearchResult[T]{
			SearchResult: index.SearchResult{
				ID:       item.ID,
				Distance: item.Distance,
			},
			Data: vg.store[item.ID],
		})
	}

	return result
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

// Remove удаляет запись по входному вектору.
func (vg *Vecgo[T]) Remove(query []float32, k int, optFns ...func(o *KNNSearchOptions)) error {
	opts := KNNSearchOptions{
		EF:         50,
		FilterFunc: func(id uint32) bool { return true },
	}

	for _, fn := range optFns {
		fn(&opts)
	}

	if opts.EF < k {
		return ErrInvalidEFValue
	}

	err := vg.index.Remove(query, k, opts.EF, opts.FilterFunc)
	if err != nil {
		return fmt.Errorf("failed to remove from index: %v", err)
	}

	return nil
}
