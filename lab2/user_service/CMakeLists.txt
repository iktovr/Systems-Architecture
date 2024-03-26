cmake_minimum_required(VERSION 3.2)

SET(BINARY "user_service")

find_package(OpenSSL)
find_package(Threads)
find_package(Poco REQUIRED COMPONENTS Foundation Util Net XML JSON Crypto NetSSL Data JWT)

if(NOT ${Poco_FOUND})
    message(FATAL_ERROR "Poco C++ Libraries not found.")
endif()

include_directories(${Poco_INCLUDE_DIRS})

SET(CMAKE_CXX_STANDARD 17)
SET(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(
    ${BINARY}
    main.cpp
)
    # config/config.cpp 
    # database/database.cpp
    # database/user.cpp
# )

target_include_directories(${BINARY} PRIVATE "${CMAKE_BINARY_DIR}")
target_compile_options(${BINARY} PRIVATE -Wall -Wextra -pedantic -Werror )
set_target_properties(${BINARY} PROPERTIES LINKER_LANGUAGE CXX)
set_target_properties(${BINARY} PROPERTIES CXX_STANDARD 17 CXX_STANDARD_REQUIRED ON)

target_link_libraries(
    ${BINARY} PRIVATE 
    ${CMAKE_THREAD_LIBS_INIT} 
    ${Poco_LIBRARIES}
    "PocoDataPostgreSQL"
)




