from _warehouse_pipeline import pipeline_warehouse
from _staging_pipeline import pipeline_staging

if __name__ == "__main__":
    pipeline_staging()
    pipeline_warehouse()