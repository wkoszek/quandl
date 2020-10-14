package main

import (
	"database/sql"
	"log"
	"time"
)

// DbGet returns a DB handler after the connection has been established
func DbGet(cfg *Config) (db *sql.DB) {
	var err error
	for i := 0; i < 10; i++ {
		db, err = sql.Open("postgres", cfg.dbStr)
		if err == nil {
			return db
		}
		log.Println("failed to connect. restarting", err)
		time.Sleep(time.Second * 1)
	}
	log.Fatal("Couldn't connect to DB")
	return nil
}
