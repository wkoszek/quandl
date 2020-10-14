package main

import (
	"fmt"
	"log"

	_ "github.com/lib/pq"
)

var isDevel bool = true

func main() {
	fmt.Println("Starting...")

	cfg := ConfigGet()
	db := DbGet(cfg)

	q := "select count(*) from fin.tickers"
	rows, err := db.Query(q)
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	fmt.Println("Processing...")

	var cnt int
	for rows.Next() {
		err := rows.Scan(&cnt)
		if err != nil {
			fmt.Print(err)
			break
		}
		fmt.Printf("cnt = %d\n", cnt)
	}
}
