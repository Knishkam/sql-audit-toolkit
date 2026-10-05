DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id BIGINT UNSIGNED NOT NULL,
  status ENUM('pending','paid','failed','refunded') NOT NULL,
  created_at DATETIME(6) NOT NULL,
  amount DECIMAL(10,2) NOT NULL DEFAULT 0,
  PRIMARY KEY (id),

  -- baseline indexes (intentionally not matching ORDER BY)
  KEY idx_status (status),
  KEY idx_user_id (user_id)
) ENGINE=InnoDB;