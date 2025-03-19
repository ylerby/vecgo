package hnsw

import (
	"sync"
)

type SyncMap struct {
	data map[[128]float32]struct{}
	m    *sync.RWMutex
}

func NewSyncMap(len int) *SyncMap {
	return &SyncMap{
		data: make(map[[128]float32]struct{}, len),
		m:    new(sync.RWMutex),
	}
}

func (sm *SyncMap) Store(key [128]float32) {
	sm.m.Lock()
	sm.data[key] = struct{}{}
	sm.m.Unlock()
}

func (sm *SyncMap) LoadWithStatus(key [128]float32) (val struct{}, ok bool) {
	sm.m.RLock()
	val, ok = sm.data[key]
	sm.m.RUnlock()

	return
}
