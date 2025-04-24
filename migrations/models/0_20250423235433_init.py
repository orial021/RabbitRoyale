from tortoise import BaseDBAsyncClient


async def upgrade(db: BaseDBAsyncClient) -> str:
    return """
        CREATE TABLE IF NOT EXISTS "error_log" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    "error_type" VARCHAR(100) NOT NULL,
    "message" TEXT NOT NULL,
    "traceback" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "status_code" VARCHAR(15),
    "created_at" TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS "items" (
    "id" CHAR(36) NOT NULL  PRIMARY KEY,
    "image_path" VARCHAR(255),
    "name" VARCHAR(100) NOT NULL,
    "description" TEXT NOT NULL,
    "type" VARCHAR(50) NOT NULL,
    "rarity" VARCHAR(50) NOT NULL,
    "value" INT NOT NULL,
    "created_at" TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMP
);
CREATE TABLE IF NOT EXISTS "users" (
    "id" CHAR(36) NOT NULL  PRIMARY KEY,
    "username" VARCHAR(50) NOT NULL UNIQUE,
    "password" VARCHAR(255) NOT NULL,
    "email" VARCHAR(255) NOT NULL UNIQUE,
    "gender" VARCHAR(6) NOT NULL  /* MALE: male\nFEMALE: female\nOTHER: other */,
    "coins" INT NOT NULL  DEFAULT 0,
    "date_of_birth" TIMESTAMP,
    "las_connection" TIMESTAMP,
    "is_active" INT NOT NULL  DEFAULT 1,
    "is_premium" INT NOT NULL  DEFAULT 0,
    "matches_played" INT NOT NULL  DEFAULT 0,
    "wins" INT NOT NULL  DEFAULT 0,
    "kills" INT NOT NULL  DEFAULT 0,
    "inventory_capacity" INT NOT NULL  DEFAULT 3,
    "created_at" TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMP
);
CREATE INDEX IF NOT EXISTS "idx_users_usernam_df2ee6" ON "users" ("username", "email");
CREATE TABLE IF NOT EXISTS "inventory" (
    "id" CHAR(36) NOT NULL  PRIMARY KEY,
    "quantity" INT NOT NULL  DEFAULT 1,
    "created_at" TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "item_id" CHAR(36) NOT NULL REFERENCES "items" ("id") ON DELETE CASCADE,
    "user_id" CHAR(36) NOT NULL REFERENCES "users" ("id") ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "aerich" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    "version" VARCHAR(255) NOT NULL,
    "app" VARCHAR(100) NOT NULL,
    "content" JSON NOT NULL
);"""


async def downgrade(db: BaseDBAsyncClient) -> str:
    return """
        """
