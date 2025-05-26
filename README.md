# 1. What is PostgreSQL?

PostgreSQL হলো একটি আধুনিক ওপেনসোর্স ওবজেক্ট রিলেশনাল ডেটাবেজ ম্যানেজমেন্ট সিস্টেম। এর বিশেষত্ব হল এটি ACID প্রোপার্টিজ মেনে চলে এবং সিকিউএল স্ট্যান্ডার্ড মেনে তৈরী করা। এছাড়াও এটি প্রায় সবধরনের ডেটা টাইপ সাপোর্ট করে ( যেমনঃ JSON/JSONB, XML, UUID, hstore ইত্যাদি ) এবং একজন ব্যবহারকারীর জন্য কাস্টম ডেটা টাইপ এবং ইন্ডেক্স টাইপ তৈরীর সুযোগ রয়েছে। বর্তমান সময়ে পাওয়ারফুল ফিচার সমৃদ্ধ নিরাপদ এবং সম্প্রসারণযোগ্য ডেটাবেজ ম্যানেজমেন্ট সিস্টেম হিসেবে PostgreSQL সবচেয়ে বেশি জনপ্রিয়।

# 2. What is the purpose of a database schema in PostgreSQL?

PostgreSQL এ Schema হলো ডেটাবেজের ভেতরে ফোল্ডারের মতো, যা মূলত ডেটাবেজ এর অব্জেক্টসমূহ (Tables, View, Functions, Index) অর্গানাইজড এবং নিরাপদ রাখে। উদ্দেশ্যঃ

- যেসব টেবিল এবং অব্জেক্ট সম্পর্কযুক্ত তাদেরকে একই ফোল্ডারে রাখা
- পৃথক পৃথক Schema তে একই নাম দিয়ে টেবিল তৈরির কারণে নেইমিং কনফ্লিক্ট এড়ানো
- বিভিন্ন Schema তে পৃথকভাবে ব্যবহারকারীর বিভিন্ন এক্সেস পার্মিশন নিয়ন্ত্রণ করা
- লজিকালি অব্জেক্টসমূহ পৃথক করা।

```sql
CREATE SCHEMA hr;

CREATE TABLE hr.employees (
  id SERIAL PRIMARY KEY,
  name TEXT,
  department TEXT
);
```

# 3. Explain the **Primary Key** and **Foreign Key** concepts in PostgreSQL

### Primary Key

প্রাইমারী কি হলো টেবিলের এমন একটি কলাম বা  এট্রিবিউট যার সাহায্যে টেবিলের প্রতিটি সারিকে পৃথকভাবে চিহ্নিত করা যায়।

বৈশিষ্ট্যঃ

- প্রাইমারী কি এর মান কখনোও NULL হতে পারবে না এবং এটি সর্বদা ইউনিক হতে হবে।
- একটি টেবিলে কেবল একটি প্রাইমারী কি থাকতে পারবে।

উদাহরণঃ

```sql
CREATE TABLE rangers(
  ranger_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  region VARCHAR(100) NOT NULL
);
```

প্রদত্ত উদাহরনে ranger_id হলো প্রাইমারি কি।

### Foreign Key

ফরেন কি টেবিলের এমন একটি কলাম বা এট্রিবিউট যার সাহায্যে দুই বা ততোধিক টেবিলে রেফারেন্সিয়াল ইন্টেগ্রিটির মাধ্যমে রিলেশন তৈরী করে। কোনো একটি টেবিলের ফরেন কি মূলত অপর একটি টেবিলের প্রাইমারী কি।

বৈশিষ্ট্যঃ

- NULL হতে পারবে না তবে ইউনিক হতেও পারে নাও হতে পারে।
- একটি টেবিলে একাধিক ফরেইন কি থাকতে পারে।

উদাহরণঃ

```sql
CREATE TABLE sightings(
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT NOT NULL REFERENCES rangers(ranger_id),
    species_id INT NOT NULL REFERENCES species(species_id),
    sighting_time TIMESTAMP NOT NULL ,
    location TEXT NOT NULL,
    notes TEXT
);
```

প্রদত্ত উদাহরণে ranger_id এবং species_id হলো ফরেইন কি যারা যথাক্রমে rangers এবং species টেবিলের প্রাইমারী কি।

# 4. What is the difference between the `VARCHAR` and `CHAR` data types?

`VARCHAR` এবং `CHAR` ডেটা টাইপের পার্থক্যঃ

| CHAR(n) | VARCHAR(n) |
| --- | --- |
| নির্দিষ্ট সংখ্যক অক্ষর সংরক্ষণ করে | পরিবর্তনশীল সংখ্যক অক্ষর সংরক্ষণ করতে পারে। |
| যদি উল্লেখিত সাইজের চেয়ে কম সংখ্যক অক্ষরবিশিষ্ট স্ট্রিং সংরক্ষণ করা হয় সেক্ষেত্রে অবশিষ্ট অংশ স্পেস দিয়ে পূরণ করে দিবে। | স্ট্রিং এর সাইজ যতটূকু ঠিক ততটুকুই জায়গা নেবে, কোনো বাড়তি স্পেস দিবে না। |
| এফিশিয়েন্টলি স্টোরেজ ব্যবহার করে না। | এফিশিয়েন্টলি স্টোরেজ ব্যবহার করে। |

উদাহরণঃ

```sql
CREATE TABLE students(
	name VARCHAR(10)
  code CHAR(5)
  
);
INSERT INTO students VALUES ('John', 'xyz');

--Stored as 'John'| 'xyz  '
```

# 5. Explain the purpose of the `WHERE` clause in a `SELECT` statement.

`SELECT` স্টেটমেন্টে নির্দিষ্ট শর্ত অনুযায়ী নির্দিষ্ট সারি(row) নির্বাচন করার জন্য **`WHERE`** ক্লজ ব্যবহার করা হয়

`WHERE` ক্লজে নিম্নোক্ত অপারেটর ব্যবহার করে বিভিন্ন শর্ত লিখা যায়:

- তুলনা অপারেটর: `=`, `!=`, `>`, `<`, `>=`, `<=`
- লজিক্যাল অপারেটর: `AND`, `OR`, `NOT`
- প্যাটার্ন মিলানো: `LIKE`
- সেটের মধ্যে: `IN`, `BETWEEN`

উদাহরণঃ

```sql
SELECT * FROM students
WHERE age > 20;
```

students টেবিলে শুধুমাত্র যেসব শিক্ষার্থীর **বয়স ২০ বছরের বেশি**, শুধু তাদের তথ্যই দেখানো হয়েছে।