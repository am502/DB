DROP TABLE IF EXISTS complex;

CREATE TABLE complex (
  r FLOAT,
  i FLOAT
);

INSERT INTO complex
  SELECT (random() * 30)::INT + 1, (random() * 30)::INT + 1 FROM generate_series(1, 100);
-- INSERT INTO complex VALUES (-2, 1), (1, -1);

ALTER TABLE complex SET (parallel_workers = 2);

DROP TYPE IF EXISTS comp CASCADE;

CREATE TYPE comp AS (
  r FLOAT,
  i FLOAT,
  amount INT
);

DROP TYPE IF EXISTS out_comp CASCADE;

CREATE TYPE out_comp AS (
  r FLOAT,
  i FLOAT
);

-- PLUS

CREATE OR REPLACE FUNCTION comp_plus_transition(
  state comp,
  r FLOAT,
  i FLOAT
) RETURNS comp AS $$
BEGIN
  IF state.amount = 0 THEN
    RETURN ROW(r, i, state.amount + 1)::comp;
  ELSE
    RETURN ROW(state.r + r, state.i + i, state.amount + 1)::comp;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION comp_plus_final(
  state comp
) RETURNS out_comp AS $$
BEGIN
  RETURN ROW(state.r, state.i)::out_comp;
END;
$$ LANGUAGE plpgsql;

CREATE AGGREGATE comp_plus(FLOAT, FLOAT) (
  sfunc = comp_plus_transition,
  stype = comp,
  finalfunc = comp_plus_final,
  initcond = '(0, 0, 0)'
);

CREATE OR REPLACE FUNCTION comp_plus_combine(
  state1 comp,
  state2 comp
) RETURNS comp AS $$
BEGIN
  RETURN ROW(state1.r + state2.r, state1.i + state2.i, state1.amount + state2.amount)::comp;
END;
$$ LANGUAGE plpgsql;

CREATE AGGREGATE comp_plus_parallel(FLOAT, FLOAT) (
  sfunc = comp_plus_transition,
  stype = comp,
  finalfunc = comp_plus_final,
  combinefunc = comp_plus_combine,
  initcond = '(0, 0, 0)',
  parallel = safe
);

-- MINUS

CREATE OR REPLACE FUNCTION comp_minus_transition(
  state comp,
  r FLOAT,
  i FLOAT
) RETURNS comp AS $$
BEGIN
  IF state.amount = 0 THEN
    RETURN ROW(r, i, state.amount + 1)::comp;
  ELSE
    RETURN ROW(state.r - r, state.i - i, state.amount + 1)::comp;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION comp_minus_final(
  state comp
) RETURNS out_comp AS $$
BEGIN
  RETURN ROW(state.r, state.i)::out_comp;
END;
$$ LANGUAGE plpgsql;

CREATE AGGREGATE comp_minus(FLOAT, FLOAT) (
  sfunc = comp_minus_transition,
  stype = comp,
  finalfunc = comp_minus_final,
  initcond = '(0, 0, 0)'
);

CREATE OR REPLACE FUNCTION comp_minus_combine(
  state1 comp,
  state2 comp
) RETURNS comp AS $$
BEGIN
  RETURN ROW(state1.r + state2.r, state1.i + state2.i, state1.amount + state2.amount)::comp;
END;
$$ LANGUAGE plpgsql;

CREATE AGGREGATE comp_minus_parallel(FLOAT, FLOAT) (
  sfunc = comp_minus_transition,
  stype = comp,
  finalfunc = comp_minus_final,
  combinefunc = comp_minus_combine,
  initcond = '(0, 0, 0)',
  parallel = safe
);

-- MULTIPLY

CREATE OR REPLACE FUNCTION comp_multiply_transition(
  state comp,
  r FLOAT,
  i FLOAT
) RETURNS comp AS $$
BEGIN
  IF state.amount = 0 THEN
    RETURN ROW(r, i, state.amount + 1)::comp;
  ELSE
    RETURN ROW(state.r * r - state.i * i, state.r * i + state.i * r, state.amount + 1)::comp;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION comp_multiply_final(
  state comp
) RETURNS out_comp AS $$
BEGIN
  RETURN ROW(state.r, state.i)::out_comp;
END;
$$ LANGUAGE plpgsql;

CREATE AGGREGATE comp_multiply(FLOAT, FLOAT) (
  sfunc = comp_multiply_transition,
  stype = comp,
  finalfunc = comp_multiply_final,
  initcond = '(0, 0, 0)'
);

CREATE OR REPLACE FUNCTION comp_multiply_combine(
  state1 comp,
  state2 comp
) RETURNS comp AS $$
BEGIN
  RETURN ROW(state1.r + state2.r, state1.i + state2.i, state1.amount + state2.amount)::comp;
END;
$$ LANGUAGE plpgsql;

CREATE AGGREGATE comp_multiply_parallel(FLOAT, FLOAT) (
  sfunc = comp_multiply_transition,
  stype = comp,
  finalfunc = comp_multiply_final,
  combinefunc = comp_multiply_combine,
  initcond = '(0, 0, 0)',
  parallel = safe
);

-- DIVIDE

CREATE OR REPLACE FUNCTION comp_divide_transition(
  state comp,
  r FLOAT,
  i FLOAT
) RETURNS comp AS $$
BEGIN
  IF state.amount = 0 THEN
    RETURN ROW(r, i, state.amount + 1)::comp;
  ELSE
    RETURN ROW((state.r * r + state.i * i) / (pow(r, 2) + pow(i, 2)),
           (r * state.i - state.r * i) / (pow(r, 2) + pow(i, 2)), state.amount + 1)::comp;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION comp_divide_final(
  state comp
) RETURNS out_comp AS $$
BEGIN
  RETURN ROW(state.r, state.i)::out_comp;
END;
$$ LANGUAGE plpgsql;

CREATE AGGREGATE comp_divide(FLOAT, FLOAT) (
  sfunc = comp_divide_transition,
  stype = comp,
  finalfunc = comp_divide_final,
  initcond = '(0, 0, 0)'
);

CREATE OR REPLACE FUNCTION comp_divide_combine(
  state1 comp,
  state2 comp
) RETURNS comp AS $$
BEGIN
  RETURN ROW(state1.r + state2.r, state1.i + state2.i, state1.amount + state2.amount)::comp;
END;
$$ LANGUAGE plpgsql;

CREATE AGGREGATE comp_divide_parallel(FLOAT, FLOAT) (
  sfunc = comp_divide_transition,
  stype = comp,
  finalfunc = comp_divide_final,
  combinefunc = comp_divide_combine,
  initcond = '(0, 0, 0)',
  parallel = safe
);

-- RESULT

EXPLAIN (ANALYZE)
SELECT comp_plus(r, i) FROM complex;

EXPLAIN (ANALYZE)
SELECT comp_minus(r, i) FROM complex;

EXPLAIN (ANALYZE)
SELECT comp_multiply(r, i) FROM complex;

EXPLAIN (ANALYZE)
SELECT comp_divide(r, i) FROM complex;

EXPLAIN (ANALYZE)
SELECT comp_plus_parallel(r, i) FROM complex;

EXPLAIN (ANALYZE)
SELECT comp_minus_parallel(r, i) FROM complex;

EXPLAIN (ANALYZE)
SELECT comp_multiply_parallel(r, i) FROM complex;

EXPLAIN (ANALYZE)
SELECT comp_divide_parallel(r, i) FROM complex;