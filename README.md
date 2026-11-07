# Chinook Database – SQL Analysis

## Overview 
This project uses SQL to explore the Chinook database, a relational database of a digital music store (customers, invoices, tracks, albums, artists, genres and employees). It contains 20 queries, from basic SELECT, filtering and sorting, through aggregations (COUNT, SUM, AVG, GROUP BY, HAVING) and JOINs between tables, to subqueries and window functions. The analytical queries include a short interpretation of the results.

## Dataset
- Source: https://www.kaggle.com/datasets/ranasabrii/chinook?resource=download
- 11 tables, the main ones being Customer, Invoice, InvoiceLine, Track, Album, Artist and Genre

## Tools
- SQLite
- DB Browser for SQLite

## SQL Concepts Used
- Filtering and sorting: WHERE, ORDER BY, LIMIT
- Aggregations: COUNT, SUM, AVG, GROUP BY, HAVING
- JOINs: INNER JOIN, LEFT JOIN
- Subqueries: scalar and correlated
- Window functions: RANK

## Key Findings
- The USA and Canada account for almost 36% of all customers (21 out of 59).
- 22 out of 59 customers spent more than the average of $39.47 per customer.
- 1519 tracks have never been purchased.
- Only 6 countries have total sales above the average of $97.03 per country; the USA leads with $523.06.
- Only 5 of the 25 genres have more than 100 tracks; Rock has the most, with 1297.

## Files
- "Chinook Project SQLite.sql": all 20 queries, with comments and interpretations
