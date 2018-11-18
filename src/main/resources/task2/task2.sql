DROP TABLE IF EXISTS genome_1_k2;
DROP TABLE IF EXISTS genome_2_k2;
DROP TABLE IF EXISTS genome_1_k5;
DROP TABLE IF EXISTS genome_2_k5;
DROP TABLE IF EXISTS genome_1_k9;
DROP TABLE IF EXISTS genome_2_k9;

CREATE TABLE genome_1_k2 (
  word VARCHAR(2)
);
CREATE TABLE genome_2_k2 (
  word VARCHAR(2)
);

CREATE TABLE genome_1_k5 (
  word VARCHAR(5)
);
CREATE TABLE genome_2_k5 (
  word VARCHAR(5)
);

CREATE TABLE genome_1_k9 (
  word VARCHAR(9)
);
CREATE TABLE genome_2_k9 (
  word VARCHAR(9)
);