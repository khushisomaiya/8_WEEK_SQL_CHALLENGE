# Week 1: Danny’s Diner

## Introduction
Danny is passionate about Japanese food, and in the beginning of 2021, he opened Danny's Diner, a cozy restaurant offering his three favorite dishes: sushi, curry, and ramen. However, while the restaurant has gathered some basic data from its first few months of operation, Danny is uncertain how to utilize this data to help improve his business.

## Problem Statement
Danny seeks help in answering some simple yet insightful questions about his customers. Specifically, he wants to know about customer spending behavior.

By understanding these aspects, Danny aims to deliver a more personalized dining experience and potentially expand his customer loyalty program. Additionally, Danny needs help generating some basic datasets so his team can easily inspect the data without needing to use SQL directly.

## Data Provided
Danny has shared three key datasets for this case study:

1. sales: Information about each transaction, including the items purchased.
2. menu: Details about the items on the restaurant's menu.
3. members: Information about customers who are part of the loyalty program.

Due to privacy concerns, Danny has provided only sample data, but it should be sufficient to write SQL queries that answer the restaurant’s key business questions.

## Entity Relationship Diagram (ERD)
<img width="418" alt="image" src="https://github.com/user-attachments/assets/9f8334c2-821c-40f7-980c-ccc86cb9ebd8" />


## My Approach
For Week 1, I followed a structured approach to solve the problem:

1. Schema Creation: I created a schema that defined the structure of the database, including the tables for sales, menu, and members, and their relationships.
   - File: 
2. Exploratory Data Analysis (EDA): I tried to understand the data by checking for any null values and identifying data discrepancies to ensure the dataset was clean and ready for analysis.
   - File:
3. Solution Files: I wrote SQL queries to answer questions related to customer spending behavior.
    - File:

## What I Learned This Week
1. Aggregate Functions: SUM(), COUNT()
2. Window Functions: DENSE_RANK(), ROW_NUMBER()
3. Conditional Logic: CASE
4. Joins: LEFT JOIN, INNER JOIN, RIGHT JOIN
5. Grouping and Sorting: GROUP BY, ORDER BY
6. Date Functions: DATE_ADD()
7. Miscellaneous: LIMIT
