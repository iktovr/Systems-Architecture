workspace {
    name "Магазин"

    !identifiers hierarchical
   
    model {
        properties {
            structurizr.groupSeparator "/"
        }

        user = person "Покупатель"
        admin = person "Администратор"

        market = softwareSystem "Магазин" {
            user_service = container "Сервис пользователей"
            item_service = container "Сервис товаров"

            group "Слой хранения" {
                user_database = container "User Database" {
                    description "База данных с пользователями и их заказами"
                    tags "database"
                }

                item_database = container "Item Database" {
                    description "База данных с товарами"
                    tags "database"
                }
            }

            user -> user_service "Регистрация пользователя"
            user -> user_service "Запрос информации о товарах"
            user -> user_service "Управление заказами"
            admin -> item_service "Актуализация товаров"
            admin -> user_service "Запрос информации о пользователях"
            user_service -> item_service "Запрос информации о товарах"
            item_service -> item_database "Получение/обновление информации о товарах"
            user_service -> user_database "Получение/обновление информации о пользователях"
        }

        user -> market "Управление заказами"
        user -> market "Запрос информации о товарах"

        production = deploymentEnvironment "Production" {
            deploymentGroup "Production"

            deploymentNode "Сервис пользователей" {
                containerInstance market.user_service
            }
            deploymentNode "Сервис товаров" {
                containerInstance market.item_service
            }

            deploymentNode "Databases" {
                deploymentNode "User Database" {
                    containerInstance market.user_database
                }
                deploymentNode "Item Database" {
                    containerInstance market.item_database
                }
            }
        }
    }

    views {
        themes default

        properties { 
            structurizr.tooltips true
        }

        systemContext market {
            autolayout
            include *
        }

        container market {
            autolayout
            include *
        }

        deployment market production {
            autoLayout
            include *
        }

        dynamic market "UC01" "Создание нового пользователя" {
            autoLayout
            user -> market.user_service "Создать нового пользователя (POST /user)"
            market.user_service -> market.user_database "Сохранить данные о пользователе"
        }

        dynamic market "UC02" "Поиск пользователя по логину" {
            autoLayout
            admin -> market.user_service "Запросить пользователей по логину (GET /user/searchByLogin)"
            market.user_service -> market.user_database "Получить данные о пользователях"
        }

        dynamic market "UC03" "Поиск пользователя по логину" {
            autoLayout
            admin -> market.user_service "Запросить пользователей по имени (GET /user/searchByName)"
            market.user_service -> market.user_database "Получить данные о пользователях"
        }

        dynamic market "UC04" "Создание товара" {
            autoLayout
            admin -> market.item_service "Создать новый товар (POST /item)"
            market.item_service -> market.item_database "Сохранить данные о товаре"
        }

        dynamic market "UC05" "Получение списка товаров" {
            autoLayout
            user -> market.user_service "Запросить список товаров (GET /items)"
            market.user_service -> market.item_service "Запросить список товаров (GET /items)"
            market.item_service -> market.item_database "Получить данные о товарах"
        }

        dynamic market "UC06" "Добавление товара в корзину" {
            autoLayout
            user -> market.user_service "Запросить добавление товара (PUT /item)"
            market.user_service -> market.item_service "Подтвердить существование товара (GET /item)"
            market.item_service -> market.item_database "Получить данные о товаре"
            market.user_service -> market.user_database "Внести изменения в корзину"
        }

        dynamic market "UC07" "Получение корзины для пользователя" {
            autoLayout
            user -> market.user_service "Запросить корзину (GET /order)"
            market.user_service -> market.user_database "Получить данные о корзине"
        }


        styles {
            element "database" {
                shape cylinder
            }
        }
    }
}
