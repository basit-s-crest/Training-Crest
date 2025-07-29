CREATE TABLE t_tag(
	id SERIAL PRIMARY KEY,
	tag text UNIQUE,
	update_time TIMESTAMP DEFAULT NOW()
);

INSERT INTO t_tag (tag)
VALUES 
('Pen'),
('Pencil');

INSERT INTO t_tag (tag)
VALUES
('Pen')
ON CONFLICT (tag)
DO 
	Nothing;


INSERT INTO t_tag (tag)  --- For tracking last update timming
VALUES
('Pen')
ON CONFLICT (tag)
DO 
	UPDATE SET
	tag = EXCLUDED.tag,
	update_time = now()
	
SELECT * FROM t_tag