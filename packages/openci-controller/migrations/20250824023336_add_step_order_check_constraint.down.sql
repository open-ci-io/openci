-- Remove CHECK constraint for step_order
ALTER TABLE workflow_steps
DROP CONSTRAINT IF EXISTS chk_step_order_nonnegative;