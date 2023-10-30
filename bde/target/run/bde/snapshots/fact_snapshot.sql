
      update "postgres"."snapshots"."fact_snapshot"
    set dbt_valid_to = DBT_INTERNAL_SOURCE.dbt_valid_to
    from "fact_snapshot__dbt_tmp201241632738" as DBT_INTERNAL_SOURCE
    where DBT_INTERNAL_SOURCE.dbt_scd_id::text = "postgres"."snapshots"."fact_snapshot".dbt_scd_id::text
      and DBT_INTERNAL_SOURCE.dbt_change_type::text in ('update'::text, 'delete'::text)
      and "postgres"."snapshots"."fact_snapshot".dbt_valid_to is null;

    insert into "postgres"."snapshots"."fact_snapshot" ("scraped_date", "listing_id", "availability_30", "number_of_reviews", "review_scores_rating", "review_scores_accuracy", "review_scores_cleanliness", "review_scores_checkin", "review_scores_communication", "review_scores_value", "price", "dbt_updated_at", "dbt_valid_from", "dbt_valid_to", "dbt_scd_id")
    select DBT_INTERNAL_SOURCE."scraped_date",DBT_INTERNAL_SOURCE."listing_id",DBT_INTERNAL_SOURCE."availability_30",DBT_INTERNAL_SOURCE."number_of_reviews",DBT_INTERNAL_SOURCE."review_scores_rating",DBT_INTERNAL_SOURCE."review_scores_accuracy",DBT_INTERNAL_SOURCE."review_scores_cleanliness",DBT_INTERNAL_SOURCE."review_scores_checkin",DBT_INTERNAL_SOURCE."review_scores_communication",DBT_INTERNAL_SOURCE."review_scores_value",DBT_INTERNAL_SOURCE."price",DBT_INTERNAL_SOURCE."dbt_updated_at",DBT_INTERNAL_SOURCE."dbt_valid_from",DBT_INTERNAL_SOURCE."dbt_valid_to",DBT_INTERNAL_SOURCE."dbt_scd_id"
    from "fact_snapshot__dbt_tmp201241632738" as DBT_INTERNAL_SOURCE
    where DBT_INTERNAL_SOURCE.dbt_change_type::text = 'insert'::text;

  