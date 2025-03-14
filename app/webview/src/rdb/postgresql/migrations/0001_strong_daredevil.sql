CREATE TABLE "account_secret" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"deleted_at" timestamp,
	"account_id" uuid NOT NULL,
	"password" text NOT NULL
);
--> statement-breakpoint
ALTER TABLE "account_secret" ADD CONSTRAINT "account_secret_account_id_account_id_fk" FOREIGN KEY ("account_id") REFERENCES "public"."account"("id") ON DELETE cascade ON UPDATE no action;