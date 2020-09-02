package main

import (
	"flag"
	"fmt"
	"os"
	"github.com/jtguibas/cinema"
)

var inputName = flag.String("input", "", "Input filename")
var outputName = flag.String("output", "", "Output filename")

func Error(what interface{}) {
	fmt.Println("ERROR:", what)
	os.Exit(1)
}

func main() {
	flag.Parse()
	if *inputName == "" {
		Error("Missing -input")
	}
	if *outputName == "" {
		Error("Missing -output")
	}

	video, err := cinema.Load(*inputName)
	if err != nil {
		Error(err)
	}

	video.Render(*outputName)
}
