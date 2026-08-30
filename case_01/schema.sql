DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  status VARCHAR(20) NOT NULL,
  created_at DATETIME NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL,
  notes VARCHAR(255),
  KEY idx_status (status)
);
