# SQL Server শেখা — সম্পূর্ণ সারাংশ (বাংলা)

এই নোট আপনার `docs/01` থেকে `10` এবং সব ল্যাব স্ক্রিপ্টের **সহজ বাংলা সারাংশ**।

---

## ১. SSMS (SQL Server Management Studio)

**SSMS** হলো SQL Server চালানোর মূল টুল।

- **Connect** → সার্ভারে যোগ দিন (Windows বা SQL লগইন)
- **New Query** → SQL লিখে **F5** চাপলে চলে
- বাম পাশে **Object Explorer** → Databases, Tables, Security

প্রথম কোয়েরি:

```sql
SELECT @@VERSION;
SELECT name FROM sys.databases;
```

**স্ক্রিপ্ট:** `sql/01-create-sample-database.sql` → `LearnSQL` ডাটাবেস তৈরি

---

## ২. SQL মৌলিক (T-SQL)

| ধরন | কাজ | উদাহরণ |
|-----|-----|---------|
| DDL | টেবিল বানানো | `CREATE TABLE` |
| DML | ডেটা পড়া/লেখা | `SELECT`, `INSERT`, `UPDATE`, `DELETE` |
| JOIN | টেবিল জোড়া | `INNER JOIN`, `LEFT JOIN` |

গুরুত্বপূর্ণ নিয়ম:

- `UPDATE`/`DELETE` এ সবসময় **`WHERE`** (না হলে সব row বদলে যাবে)
- `NULL` চেক: `IS NULL`, `= NULL` নয়

**স্ক্রিপ্ট:** `02`, `03`, `04`

---

## ৩. সার্ভার ম্যানেজমেন্ট

চারটি সিস্টেম ডাটাবেস: `master`, `model`, `msdb`, `tempdb`

| Recovery Model | মানে |
|----------------|------|
| SIMPLE | ছোট ডেভ, লগ সহজ |
| FULL | প্রোডাকশন, পয়েন্ট-ইন-টাইম রিস্টোর |

কাজ:

- **BACKUP DATABASE** → `.bak` ফাইল
- **RESTORE DATABASE** → টেস্ট করুন (শুধু ব্যাকআপ নয়, রিস্টোর প্রমাণ দরকার)
- **DBCC CHECKDB** → ডাটাবেস ঠিক আছে কিনা

**স্ক্রিপ্ট:** `09`, `12` — ফোল্ডার: `C:\Temp\SqlBackups`

---

## ৪. অ্যাডভান্সড ডেভেলপার

| জিনিস | ব্যবহার |
|--------|---------|
| **View** | সংরক্ষিত SELECT (ভার্চুয়াল টেবিল) |
| **Stored Procedure** | অ্যাপের লজিক ডাটাবেসে |
| **Function** | হিসাব / ছোট রিটার্ন |
| **Trigger** | INSERT/UPDATE/DELETE এ অটো কাজ |
| **Transaction** | সব সফল না হলে **ROLLBACK** |

`TRY/CATCH` + `ROLLBACK` = নিরাপদ ট্রানজেকশন

**স্ক্রিপ্ট:** `05`, `06`, `07`, `13`

---

## ৫. সিকিউরিটি

- **Login** = সার্ভার লেভেল (প্রবেশ)
- **User** = ডাটাবেস লেভেল
- **Role** = অনুমতির গ্রুপ (`db_datareader` ইত্যাদি)

নিয়ম:

- **Least privilege** — শুধু যা দরকার (`SELECT` only অ্যাপের জন্য)
- **`sa` ব্যবহার করবেন না** অ্যাপে
- **Parameterized query** → SQL injection রোধ

**স্ক্রিপ্ট:** `08`, `14` — লগইন `Learn_AppReader`

---

## ৬. প্রোডাকশন

পরিবেশ: **Dev → Test → Staging → Prod**

| শব্দ | অর্থ |
|------|------|
| **RPO** | কত ডেটা হারাতে পারবেন |
| **RTO** | কত দ্রুত সার্ভিস চালু করতে হবে |

চেকলিস্ট: ব্যাকআপ, রিস্টোর টেস্ট, মনিটরিং, রানবুক

**ডক:** `06`, `12` — **স্ক্রিপ্ট:** `15`

---

## ৭. ERD ও ডাটাবেস ডিজাইন

**ERD** = টেবিল + সম্পর্ক (১:১, ১:অনেক, অনেক:অনেক → **junction table**)

**Normalization (সংক্ষেপ):**

- **1NF** — এক কলামে এক মান
- **2NF** — আংশিক নির্ভরতা নেই
- **3NF** — ট্রানজিটিভ নির্ভরতা নেই (CustomerCity শুধু Order row এ রাখা ভুল)

**স্ক্রিপ্ট:** `11` (Library), `16` (Hospital)

---

## ৮. ডেটা ফ্লো (DFD)

- **Context diagram** — পুরো সিস্টেম এক বক্স
- **Level 1** — প্রসেস: Issue Loan, Return Book, ডেটা স্টোর D1

DFD → SQL: প্রসেস = Stored Procedure, D1 = Database

**ডক:** `08`, `13-design-workbook`

---

## ৯. পারফরম্যান্স ও স্কেলেবিলিটি

টিউনিং ধাপ:

1. পরিমাপ করুন (plan, logical reads, wait stats)
2. সমস্যা খুঁজুন (scan? blocking?)
3. ঠিক করুন (index, query rewrite)
4. আবার পরিমাপ

| ইনডেক্স | কাজ |
|---------|-----|
| Clustered | সাধারণত PK, টেবিলের physical order |
| Nonclustered | WHERE/JOIN কলাম |
| Covering | `INCLUDE` — Key Lookup কমায় |

**স্কেল আউট:** Read replica, caching, partitioning, queue

**স্ক্রিপ্ট:** `10`, `17`

---

## ১০. টাইম কমপ্লেক্সিটি (Big O)

| অপারেশন | সাধারণত |
|----------|---------|
| Index Seek | O(log n) |
| Table Scan | O(n) |
| Sort | O(n log n) |
| Correlated subquery বড় ডেটায় | O(n²) এর মতো খারাপ |

**Sargable:** কলামে ফাংশন দেবেন না — `YEAR(OrderDate)=2026` ❌  
→ `OrderDate >= '2026-01-01' AND OrderDate < '2027-01-01'` ✅

**Pagination:** গভীর পেজে `OFFSET` ধীর → `WHERE Id > @LastId` দ্রুত

---

## স্ক্রিপ্ট ম্যাপ (সব ফাইল)

| স্ক্রিপ্ট | বিষয় |
|----------|--------|
| 01 | LearnSQL তৈরি |
| 02–04 | DDL, CRUD, JOIN |
| 05–07, 13 | Index, procedure, trigger |
| 08, 14 | Security |
| 09, 12, 15 | Backup, monitoring, production check |
| 11, 16 | Library, Hospital design |
| 10, 17 | Performance lab |

---

## পরবর্তী ধাপ

1. **[COURSE-COMPLETE.md](../COURSE-COMPLETE.md)** — পোর্টফোলিও আইডিয়া  
2. **`sql/18-school-database.sql`** — নতুন স্কুল প্রজেক্ট (নিচের লেসন)  
3. Microsoft Learn + নিজের ছোট অ্যাপ (C# / Python + SQL Server)

---

## দৈনিক অনুশীলন (১৫ মিনিট)

- একটি `SELECT` + `JOIN` লিখুন  
- একটি query এর **execution plan** দেখুন  
- একটি নতুন শব্দ: wait type, seek, RPO — নোট করুন

শুভকামনা — **আপনি পুরো কোর্স পাঠ শেষ করেছেন।** 🎓
