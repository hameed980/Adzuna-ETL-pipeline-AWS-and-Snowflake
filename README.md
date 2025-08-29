# Adzuna Jobs ETL Pipeline (AWS + Snowflake)

## 📌 Overview
An end-to-end **cloud ETL pipeline** that ingests job postings from the **Adzuna API**, lands raw JSON in **Amazon S3**, transforms it with **AWS Glue (Spark)**, and loads analytics-ready data into **Snowflake** using **Snowpipe**. The pipeline is automated with **EventBridge** (schedule) and **Step Functions** (orchestration).

---

## 🏗️ Architecture

![Architecture Diagram](b852656e-dd98-4745-bc5c-cd709bc55309.png)

**Flow**
1) **EventBridge** triggers daily  
2) **Step Functions** orchestrate  
3) **Lambda (Python)** extracts Adzuna API → **S3 (raw)**  
4) **Glue (Spark)** transforms → **S3 (transformed)**  
5) **Snowpipe** auto-ingests → **Snowflake** tables

---

## 🧰 Tech Stack
- **Source:** Adzuna Jobs API  
- **AWS:** EventBridge, Step Functions, Lambda (Python 3.12), S3, Glue (Spark)  
- **Warehouse:** Snowflake + Snowpipe (auto_ingest)  
- **Lang:** Python (Lambda), PySpark (Glue)

---

## 🚀 Quick Start

### 1) Clone
```bash
git clone https://github.com/hameed980/a.git
cd adzuna-etl-pipeline
