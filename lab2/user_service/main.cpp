#include "../server/http_server.h"
#include "http_request_factory.h"

int main(int argc, char * argv[]) {
    HTTPWebServer<HTTPRequestFactory> app;
    return app.run(argc, argv);
}