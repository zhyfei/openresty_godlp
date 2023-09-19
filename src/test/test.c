#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int NewEngine(const char* conf_path, char *namespace, void** engine);
extern int Deidentify(void* engine, const char* inputText, char** outputText, unsigned long* outlen);
extern void Close(void* engine);
extern void FreeString(char* s);

int main() {
    const char* confPath = "./conf.yml";
    const char* inputText = "我的邮件是abcd@abcd.com, \
18612341234是我的手机 \
你家住在哪里啊?我家住在北京市海淀区北三环西路43号905栋723单元502号, \
06-06-06-aa-bb-cc \
收件人：张三飞 号:13012345678 域名:www.mytest.com";

    // Create the engine
    void* engine;
    int ret = NewEngine(confPath, "namespace1", &engine);
    if (ret != 0) {
        printf("Failed to create the engine.\n");
        return 1;
    }

    // void* engine = NewEngineC(confPath);
    // if (!engine) {
    //     printf("Failed to create the engine.\n");
    //     return 1;
    // }
    printf("engine init success\n");
   // Deidentify the input text
    char* outputText;
    unsigned long outlen;
    int result = Deidentify(engine, inputText, &outputText, &outlen);
    if (result != 0) {
        printf("Deidentification failed.\n");
        Close(engine);
        return 1;
    }
    // Print the deidentified text
    printf("Deidentified Text: %s\n", outputText);

    // Free the outputText
    FreeString(outputText);

    // Close the engine
    Close(engine);

    // return 0;
}
