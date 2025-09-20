-- Add CHECK constraint to enforce non-negative step_order values
ALTER TABLE workflow_steps
ADD CONSTRAINT chk_step_order_nonnegative
CHECK (step_order >= 0);
