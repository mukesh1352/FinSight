
## Beginner-friendly implementation roadmap

Follow the phases in order. Each phase should produce a working deliverable.

### Phase 0: Understand the data and plan

Learn CSV structure, data types, missing values, Git, and data dictionaries.

Tasks:

1. Select a suitable public, appropriately licensed transaction dataset or create a small synthetic fixture.
2. Inspect sample rows and identify each column.
3. Document the dataset source, license, date downloaded, and any filtering.
4. Define required columns, types, nullability, date assumptions, amount/currency assumptions, and allowed categories.

**Deliverable:** Dataset documentation and a small test fixture.

### Phase 1: Python, Pandas, and quality checks

Learn functions, modules, exceptions, file paths, logging, Pandas DataFrames, and pytest.

Tasks:

1. Read a CSV.
2. Validate required columns and data types.
3. Preserve original descriptions while creating normalized descriptions.
4. Identify missing and invalid values.
5. Detect exact duplicate rows and flag potential duplicates.
6. Calculate monthly and category-level totals.
7. Export a data-quality report.
8. Add tests for each important function.

**Deliverable:** A tested command-line pipeline that processes a small CSV and produces repeatable outputs.

### Phase 2: PostgreSQL and reliable ingestion

Learn tables, primary/foreign keys, indexes, constraints, SQL queries, transactions, and database connections.

Tasks:

1. Start PostgreSQL through Docker Compose.
2. Create `import_batches`, `raw_transactions`, and `transactions` tables.
3. Store raw and curated records separately.
4. Track row counts and import status.
5. Implement an idempotency strategy so reprocessing does not unintentionally duplicate accepted records.
6. Record failed imports and useful error information.

**Deliverable:** A repeatable CSV-to-PostgreSQL ingestion pipeline.

### Phase 3: SQL and dbt Core

Learn joins, aggregates, CTEs, window functions, and modular SQL modeling.

Tasks:

1. Build staging models over curated transactions.
2. Build intermediate models and financial marts.
3. Add suitable tests such as `not_null`, `unique`, `relationships`, and accepted values.
4. Add custom reconciliation checks.
5. Document the model dependencies and metric definitions.

**Deliverable:** Tested, documented financial analytics models.

### Phase 4: Traditional machine learning

Learn train/test splits, text vectorization, feature preprocessing, leakage prevention, and classification metrics.

Tasks:

1. Define the transaction-category prediction task and labels.
2. Create a simple baseline.
3. Train Logistic Regression using an appropriate feature pipeline.
4. Evaluate Random Forest with attention to memory and runtime.
5. Compare models using the same data split and evaluation policy.
6. Report accuracy, macro F1, weighted F1, per-class precision/recall, and a confusion matrix.

**Deliverable:** Reproducible model comparison with saved configuration and measured results.

### Phase 5: Controlled data-quality experiments

Create separate copies of the reference dataset and inject one defect type at a time.

Experiments may include duplicate rows, missing values, inconsistent descriptions, invalid values, or label noise. Record the random seed and defect rate.

Run the same pipeline against reference, corrupted, and quality-controlled variants. Compare financial totals, rejected rows, quality-rule outcomes, reconciliation differences, and model metrics.

**Deliverable:** A documented experiment report. Do not invent or pre-fill results before running the experiments.

### Phase 6: Small PyTorch experiment

Only after the traditional models work, build a compact neural network. Keep the data split and evaluation policy consistent with the other models. Track training time, memory where practical, and relevant metrics. A more complex model is not automatically better.

**Deliverable:** An evidence-based comparison that includes limitations.

### Phase 7: FastAPI and dashboard

Build FastAPI endpoints over real pipeline outputs, with Pydantic request/response validation. Then build a Next.js dashboard to show imports, quality findings, analytics, model evaluations, and pipeline runs.

**Deliverable:** A dashboard backed by the actual API rather than hardcoded metrics.

### Phase 8: Orchestration

Once each pipeline task works independently, introduce Apache Airflow to schedule tasks, handle retries, and expose task status. Follow the official Airflow Docker Compose guidance; Airflow needs additional setup and resources.

**Deliverable:** A repeatable, observable multi-step workflow.

### Phase 9: Scalability and storage benchmarks

Compare Pandas with PySpark and CSV with Parquet on documented dataset sizes. Measure runtime and memory where practical, and record machine specifications and experiment settings.

**Deliverable:** A benchmark report with honest trade-offs. Spark is optional if the tested dataset does not justify it.
