package main

import (
	"fmt"
	"log"
	"time"

	"github.com/ylerby/vecgo"
	"github.com/ylerby/vecgo/index/hnsw"
	"github.com/ylerby/vecgo/util"
)

func main() {
	seed := int64(4711)
	dim := 32
	size := 50000
	k := 10

	vg := vecgo.NewHNSW[int](func(o *hnsw.Options) {
		o.M = 32
		// o.EF = 200
		// o.Heuristic = false
	}) // nolint wsl

	rng := util.NewRNG(seed)

	items := make([]vecgo.VectorWithData[int], 0, size)
	for i, v := range rng.GenerateRandomVectors(size, dim) {
		items = append(items, vecgo.VectorWithData[int]{
			Vector: v,
			Data:   i,
		})
	}

	query := rng.GenerateRandomVectors(1, dim)[0]

	fmt.Println("--- Insert ---")
	fmt.Println("Dimension:", dim)
	fmt.Println("Size:", size)

	start := time.Now()

	for _, item := range items {
		_, err := vg.Insert(item)
		if err != nil {
			log.Fatal(err)
		}
	}

	end := time.Since(start)

	fmt.Printf("Seconds: %.2f\n\n", end.Seconds())

	vg.PrintStats()
	fmt.Println()

	var (
		err    error
		result []vecgo.SearchResult[int]
	)

	fmt.Println("--- KNN ---")

	start = time.Now()

	result, err = vg.KNNSearch(query, k, func(o *vecgo.KNNSearchOptions) {
		o.EF = 80
		// o.FilterFunc = func(id uint32) bool {
		// 	return id%2 == 0
		// }
	}) // nolint wsl
	if err != nil {
		log.Fatal(err)
	}

	end = time.Since(start)

	printResult(result)

	fmt.Printf("Seconds: %.8f\n\n", end.Seconds())

	fmt.Println("--- Brute ---")

	start = time.Now()

	result, err = vg.BruteSearch(query, k, func(o *vecgo.BruteSearchOptions) {
		// o.FilterFunc = func(id uint32) bool {
		// 	return id%2 == 0
		// }
	}) // nolint wsl
	if err != nil {
		log.Fatal(err)
	}

	end = time.Since(start)

	printResult(result)

	fmt.Printf("Seconds: %.8f\n\n", end.Seconds())
}

func printResult[T any](result []vecgo.SearchResult[T]) {
	for _, r := range result {
		fmt.Printf("ID: %d, Distance: %.2f, Data: %v\n", r.ID, r.Distance, r.Data)
	}
}
