CREATE OR REPLACE VIEW
  `moz-fx-data-shared-prod.subscription_platform.nonprod_stripe_subscriptions`
AS
SELECT
  customer_id,
  fxa_uid,
  subscription_id,
  subscription_item_id,
  synced_at AS event_timestamp,
  created,
  trial_start,
  trial_end,
  subscription_start_date,
  cancel_at,
  cancel_at_period_end,
  canceled_at,
  canceled_for_customer_at,
  ended_at,
  status,
  product_id,
  product_name,
  product_capabilities,
  plan_id,
  plan_started_at,
  plan_ended_at,
  plan_name,
  plan_capabilities,
  plan_amount,
  billing_scheme,
  plan_currency,
  plan_interval,
  plan_interval_count,
  plan_interval_timezone,
  provider,
  country,
  promotion_codes,
  promotion_discounts_amount,
FROM
  `moz-fx-data-shared-prod`.subscription_platform.nonprod_stripe_subscriptions_history
WHERE
  -- Only include the current history records.
  valid_to IS NULL
  AND status NOT IN ("incomplete", "incomplete_expired")
