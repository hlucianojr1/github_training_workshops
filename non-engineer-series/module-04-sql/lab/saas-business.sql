-- CloudMetrics SaaS Business Database
-- Module 04 Lab: SQL Without Fear
-- Compatible with: SQLite, PostgreSQL, MySQL
-- IMPORTANT: This is sample data only. Never run generated SQL on a production database without developer review.

-- =============================================
-- SCHEMA
-- =============================================

CREATE TABLE customers (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  plan TEXT NOT NULL CHECK(plan IN ('starter','growth','enterprise')),
  mrr REAL NOT NULL,
  signup_date TEXT NOT NULL,
  churn_date TEXT
);

CREATE TABLE products (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  price_tier TEXT NOT NULL CHECK(price_tier IN ('starter','growth','enterprise'))
);

CREATE TABLE invoices (
  id INTEGER PRIMARY KEY,
  customer_id INTEGER NOT NULL REFERENCES customers(id),
  amount REAL NOT NULL,
  invoice_date TEXT NOT NULL,
  status TEXT NOT NULL CHECK(status IN ('paid','pending','overdue'))
);

CREATE TABLE support_tickets (
  id INTEGER PRIMARY KEY,
  customer_id INTEGER NOT NULL REFERENCES customers(id),
  subject TEXT NOT NULL,
  created_at TEXT NOT NULL,
  resolved_at TEXT,
  severity TEXT NOT NULL CHECK(severity IN ('low','medium','high','critical'))
);

-- =============================================
-- SEED DATA
-- =============================================

INSERT INTO customers (id, name, plan, mrr, signup_date, churn_date) VALUES
  (1,  'Apex Consulting',      'enterprise', 4500.00, '2023-01-15', NULL),
  (2,  'Blue River Media',     'growth',     1200.00, '2023-02-01', NULL),
  (3,  'Cascade Logistics',    'starter',     299.00, '2023-03-10', NULL),
  (4,  'Dune Analytics',       'enterprise', 6200.00, '2022-11-20', NULL),
  (5,  'Echo Marketing',       'growth',      980.00, '2023-04-05', '2023-10-15'),
  (6,  'Fern Legal Group',     'starter',     299.00, '2023-05-22', NULL),
  (7,  'Glacier Finance',      'enterprise', 8100.00, '2022-09-30', NULL),
  (8,  'Harbor Health',        'growth',     1500.00, '2023-06-01', NULL),
  (9,  'Iris Software',        'starter',     299.00, '2023-07-14', '2024-01-20'),
  (10, 'Jade Retail Co',       'growth',     1100.00, '2023-08-08', NULL),
  (11, 'Karma Cloud',          'enterprise', 5500.00, '2023-01-01', NULL),
  (12, 'Luma Design Studio',   'starter',     299.00, '2023-09-03', NULL),
  (13, 'Mesa Tech',            'growth',      850.00, '2023-10-17', '2024-02-28'),
  (14, 'Nova Partners',        'enterprise', 7200.00, '2022-12-01', NULL),
  (15, 'Orbit Systems',        'growth',     1350.00, '2023-11-11', NULL),
  (16, 'Pine Valley Realty',   'starter',     299.00, '2023-12-01', NULL),
  (17, 'Quartz Capital',       'enterprise', 9100.00, '2022-10-15', NULL),
  (18, 'Ridge Operations',     'growth',      920.00, '2024-01-05', NULL),
  (19, 'Summit Education',     'starter',     299.00, '2024-01-20', '2024-03-15'),
  (20, 'Terra Biotech',        'enterprise', 4800.00, '2023-02-14', NULL),
  (21, 'Union Square Apps',    'growth',     1700.00, '2023-03-22', NULL),
  (22, 'Valley Creek HR',      'starter',     299.00, '2023-04-10', NULL),
  (23, 'Wave Commerce',        'growth',     1050.00, '2023-05-01', '2024-02-01'),
  (24, 'Xenon Labs',           'enterprise', 3900.00, '2023-06-15', NULL),
  (25, 'Zara Networks',        'growth',     1250.00, '2023-07-07', NULL);

INSERT INTO products (id, name, price_tier) VALUES
  (1, 'CloudMetrics Starter',    'starter'),
  (2, 'CloudMetrics Growth',     'growth'),
  (3, 'CloudMetrics Enterprise', 'enterprise');

INSERT INTO invoices (id, customer_id, amount, invoice_date, status) VALUES
  (1,  1,  4500.00, '2024-01-01', 'paid'),
  (2,  1,  4500.00, '2024-02-01', 'paid'),
  (3,  1,  4500.00, '2024-03-01', 'pending'),
  (4,  2,  1200.00, '2024-01-01', 'paid'),
  (5,  2,  1200.00, '2024-02-01', 'overdue'),
  (6,  3,   299.00, '2024-01-01', 'paid'),
  (7,  4,  6200.00, '2024-01-01', 'paid'),
  (8,  4,  6200.00, '2024-02-01', 'paid'),
  (9,  4,  6200.00, '2024-03-01', 'paid'),
  (10, 5,   980.00, '2023-08-01', 'paid'),
  (11, 5,   980.00, '2023-09-01', 'paid'),
  (12, 6,   299.00, '2024-01-01', 'paid'),
  (13, 6,   299.00, '2024-02-01', 'overdue'),
  (14, 7,  8100.00, '2024-01-01', 'paid'),
  (15, 7,  8100.00, '2024-02-01', 'paid'),
  (16, 8,  1500.00, '2024-01-01', 'paid'),
  (17, 8,  1500.00, '2024-02-01', 'overdue'),
  (18, 9,   299.00, '2023-11-01', 'paid'),
  (19, 10, 1100.00, '2024-01-01', 'paid'),
  (20, 10, 1100.00, '2024-02-01', 'paid'),
  (21, 11, 5500.00, '2024-01-01', 'paid'),
  (22, 11, 5500.00, '2024-02-01', 'paid'),
  (23, 11, 5500.00, '2024-03-01', 'pending'),
  (24, 12,  299.00, '2024-01-01', 'paid'),
  (25, 13,  850.00, '2024-01-01', 'overdue'),
  (26, 13,  850.00, '2024-02-01', 'overdue'),
  (27, 14, 7200.00, '2024-01-01', 'paid'),
  (28, 14, 7200.00, '2024-02-01', 'paid'),
  (29, 15, 1350.00, '2024-01-01', 'paid'),
  (30, 15, 1350.00, '2024-02-01', 'pending'),
  (31, 16,  299.00, '2024-01-01', 'paid'),
  (32, 17, 9100.00, '2024-01-01', 'paid'),
  (33, 17, 9100.00, '2024-02-01', 'paid'),
  (34, 17, 9100.00, '2024-03-01', 'paid'),
  (35, 18,  920.00, '2024-02-01', 'paid'),
  (36, 19,  299.00, '2024-02-01', 'overdue'),
  (37, 20, 4800.00, '2024-01-01', 'paid'),
  (38, 20, 4800.00, '2024-02-01', 'paid'),
  (39, 21, 1700.00, '2024-01-01', 'paid'),
  (40, 21, 1700.00, '2024-02-01', 'overdue'),
  (41, 21, 1700.00, '2024-03-01', 'overdue'),
  (42, 22,  299.00, '2024-01-01', 'paid'),
  (43, 23, 1050.00, '2024-01-01', 'paid'),
  (44, 24, 3900.00, '2024-01-01', 'paid'),
  (45, 24, 3900.00, '2024-02-01', 'paid'),
  (46, 25, 1250.00, '2024-01-01', 'paid'),
  (47, 25, 1250.00, '2024-02-01', 'paid'),
  (48, 2,  1200.00, '2024-03-01', 'overdue'),
  (49, 6,   299.00, '2024-03-01', 'overdue'),
  (50, 8,  1500.00, '2024-03-01', 'overdue');

INSERT INTO support_tickets (id, customer_id, subject, created_at, resolved_at, severity) VALUES
  (1,  1,  'Cannot export dashboard to PDF',              '2024-01-10 09:00:00', '2024-01-11 14:00:00', 'medium'),
  (2,  1,  'SSO configuration not working',               '2024-02-05 10:30:00', '2024-02-06 11:00:00', 'high'),
  (3,  2,  'Billing portal shows wrong amount',           '2024-01-15 08:00:00', '2024-01-16 09:00:00', 'high'),
  (4,  3,  'How do I add a second user?',                 '2024-01-20 14:00:00', '2024-01-20 15:00:00', 'low'),
  (5,  4,  'API rate limit exceeded',                     '2024-01-08 11:00:00', '2024-01-09 10:00:00', 'critical'),
  (6,  4,  'Webhook not firing on event trigger',         '2024-02-12 09:00:00', '2024-02-14 16:00:00', 'high'),
  (7,  5,  'Data not syncing after plan change',          '2023-09-01 10:00:00', '2023-09-02 12:00:00', 'medium'),
  (8,  6,  'Password reset email not arriving',           '2024-02-01 08:00:00', NULL,                  'medium'),
  (9,  7,  'Performance degradation on large reports',    '2024-01-25 14:00:00', '2024-01-27 10:00:00', 'high'),
  (10, 7,  'Missing data in January export',              '2024-02-15 09:00:00', NULL,                  'critical'),
  (11, 8,  'Mobile app crashing on iOS 17',               '2024-01-18 16:00:00', '2024-01-22 13:00:00', 'high'),
  (12, 9,  'Cannot delete historical records',            '2023-12-01 09:00:00', '2023-12-02 10:00:00', 'low'),
  (13, 10, 'Integration with Slack broken',               '2024-01-30 11:00:00', '2024-02-01 09:00:00', 'medium'),
  (14, 11, 'Onboarding wizard does not save progress',    '2024-01-12 10:00:00', '2024-01-13 14:00:00', 'medium'),
  (15, 11, 'SAML assertion error on login',               '2024-02-20 09:00:00', NULL,                  'critical'),
  (16, 12, 'How do I export my data?',                    '2024-01-05 13:00:00', '2024-01-05 14:00:00', 'low'),
  (17, 13, 'Duplicate invoice sent',                      '2024-01-22 10:00:00', '2024-01-23 11:00:00', 'medium'),
  (18, 14, 'Custom domain setup failing',                 '2024-01-16 09:00:00', '2024-01-18 15:00:00', 'high'),
  (19, 14, 'Data retention policy not applying',          '2024-02-08 10:00:00', '2024-02-09 16:00:00', 'high'),
  (20, 15, 'Chart rendering broken in Firefox',           '2024-02-03 14:00:00', '2024-02-04 11:00:00', 'medium'),
  (21, 17, 'Audit log not capturing all events',          '2024-01-29 09:00:00', NULL,                  'critical'),
  (22, 17, 'IP allowlist not working correctly',          '2024-02-25 10:00:00', NULL,                  'high'),
  (23, 18, 'How to set up team permissions?',             '2024-02-10 11:00:00', '2024-02-10 12:00:00', 'low'),
  (24, 20, 'Data import fails for large CSV files',       '2024-01-14 09:00:00', '2024-01-16 14:00:00', 'medium'),
  (25, 21, 'API documentation link returns 404',          '2024-02-18 10:00:00', '2024-02-19 09:00:00', 'low');
