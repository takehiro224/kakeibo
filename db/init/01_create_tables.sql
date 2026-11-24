-- 利用者テーブル
CREATE TABLE accounts (
    account_id INTEGER PRIMARY KEY,
    account_name VARCHAR(30) NOT NULL
);

-- 費目テーブル
CREATE TABLE expenses (
    expense_id CHAR(3) PRIMARY KEY,
    expense_name VARCHAR(30) NOT NULL UNIQUE,
    category CHAR(1) NOT NULL
        CHECK (category IN ('I', 'O'))
);

-- 入出金行為テーブル
CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    transaction_date DATE NOT NULL,
    account_id INTEGER NOT NULL REFERENCES accounts(account_id),
    note VARCHAR(100)
);

-- 入出金明細テーブル
CREATE TABLE transaction_items (
    item_id SERIAL PRIMARY KEY,
    transaction_id INTEGER NOT NULL REFERENCES transactions(transaction_id),
    expense_id CHAR(3) NOT NULL REFERENCES expenses(expense_id),
    amount INTEGER NOT NULL DEFAULT 0 CHECK (amount > 0),
    UNIQUE (transaction_id, expense_id)
);

-- タグテーブル
CREATE TABLE tags (
    tag_id SERIAL PRIMARY KEY,
    note VARCHAR(100),
    author_id INTEGER NOT NULL REFERENCES accounts(account_id)
);

-- タグ付けテーブル
CREATE TABLE taggings (
    tag_id INTEGER NOT NULL REFERENCES tags(tag_id),
    transaction_id INTEGER NOT NULL REFERENCES transactions(transaction_id),
    PRIMARY KEY (tag_id, transaction_id)
);

-- 初期データ投入
-- 利用者テーブル
INSERT INTO accounts (account_id, account_name) VALUES
(1, '立花いずみ'),
(2, '立花コウジ'),
(3, '立花はると');

-- 費目テーブル(I=収入, O=支出)
INSERT INTO expenses (expense_id, expense_name, category) VALUES
('H01', '住居費', 'O'),
('H17', '振込手数料', 'O'),
('H19', '図書費', 'O'),
('H03', '飲食費', 'O'),
('I01', '給与', 'I');

-- 入出金行為テーブル(transaction_idはSERIALのため指定不要 → 1, 2, 3が採番される)
INSERT INTO transactions (transaction_date, account_id, note) VALUES
('2026-07-31', 1, '家賃振り込み'),
('2026-08-01', 2, 'React入門'),
('2026-08-01', 2, '会食');

-- 入出金明細テーブル(transaction_id = 1, 2, 3に対応)
INSERT INTO transaction_items (transaction_id, expense_id, amount) VALUES
(1, 'H01', 65000),
(1, 'H17', 525),
(2, 'H19', 2730),
(3, 'H03', 11000);

-- タグテーブル(tag_idはSERIALのため指定不要 → 1, 2, 3が採番される)
INSERT INTO tags (note, author_id) VALUES
('固定費', 1),
('自己投資', 2),
('交際費', 2);

-- タグ付けテーブル(tag_id = 1, 2, 3 / transaction_id = 1, 2, 3に対応)
INSERT INTO taggings (tag_id, transaction_id) VALUES
(1, 1),
(2, 2),
(3, 3);