DROP TABLE IF EXISTS document_1;
DROP TABLE IF EXISTS document_2;
DROP TABLE IF EXISTS document_3;
DROP TABLE IF EXISTS document_4;
DROP TABLE IF EXISTS document_5;

CREATE TABLE document_1 (
  doc_num INT,
  word VARCHAR,
  quantity INT
);

CREATE TABLE document_2 (
  doc_num INT,
  word VARCHAR,
  quantity INT
);

CREATE TABLE document_3 (
  doc_num INT,
  word VARCHAR,
  quantity INT
);

CREATE TABLE document_4 (
  doc_num INT,
  word VARCHAR,
  quantity INT
);

CREATE TABLE document_5 (
  doc_num INT,
  word VARCHAR,
  quantity INT
);

CREATE TABLE stop_words (
  word VARCHAR
);