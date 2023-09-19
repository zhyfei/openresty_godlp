package main

// #include <stdlib.h>
import "C"
import (
	"fmt"
	"unsafe"
	dlp "github.com/bytedance/godlp"
	"github.com/bytedance/godlp/dlpheader"
)

var API *dlpheader.EngineAPI

type Engine struct {
	Version  string
	callerID string
	API      *dlpheader.EngineAPI
}

//export NewEngine
func NewEngine(conf_path *C.char, namespace *C.char, handle *unsafe.Pointer) C.int {
	confPathStr := C.GoString(conf_path)
	namespaceStr := C.GoString(namespace)
	eng, err := dlp.NewEngine(namespaceStr)
	if err != nil {
		fmt.Println(err)
		return C.int(-1)
	}
	err = eng.ApplyConfigFile(confPathStr)
	if err != nil {
		fmt.Println(err)
		return C.int(-1)
	}
	API = &eng
	myeng := &Engine{
		Version:  eng.GetVersion(),
		callerID: namespaceStr,
		API:      &eng,
	}
	*handle = unsafe.Pointer(myeng)
	return C.int(0)
}

//export NewEngineC
func NewEngineC(conf_path *C.char) unsafe.Pointer {
	confPathStr := C.GoString(conf_path)

	eng, err := dlp.NewEngine("chiansec")
	if err != nil {
		fmt.Println(err)
		return nil
	}
	err = eng.ApplyConfigFile(confPathStr)
	if err != nil {
		fmt.Println(err)
		return nil
	}
	myeng := &Engine{
		Version:  eng.GetVersion(),
		callerID: "chiansec",
		API:      &eng,
	}
	return unsafe.Pointer(myeng)
}

//export Deidentify
func Deidentify(engine unsafe.Pointer, inputText *C.char, outputText **C.char, outlen *C.ulong) C.int {

	//myeng := (*Engine)(engine)
	inputTextStr := C.GoString(inputText)
	//handle := *myeng.API
	resultText, _, err := (*API).Deidentify(inputTextStr)
	if err != nil {
		return C.int(-1)
	}
	// Set the outputText and outlen to the appropriate values
	cResultText := C.CString(resultText)
	*outlen = C.ulong(len(resultText))
	// Set the outputText to point to cResultText
	*outputText = cResultText
	return C.int(0)
}

//export Close
func Close(engine unsafe.Pointer) {
	// myeng := (*Engine)(engine)
	handle := *API
	handle.Close()
}

//export FreeString
func FreeString(s *C.char) {
	C.free(unsafe.Pointer(s))
}

func main(){
}
