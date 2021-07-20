-- Find the oldest users. -- 
select * from users
order by created_at
limit 10;

-- What days of the week do users register on most? This is critical info before we launch an ad campaign. --
select date_format(created_at, '%W') as Weekday,
	count(*) as Total
from users
group by Weekday
order by Total desc;

-- Who has never posted on our platform? --
SELECT username as Ghosts
FROM users
LEFT JOIN photos ON users.id = photos.user_id
WHERE photos.id IS NULL;

-- Which user has the most liked post? -- 
SELECT users.username,COUNT(*) AS Total_Likes
FROM likes
JOIN photos ON photos.id = likes.photo_id
JOIN users ON users.id = likes.user_id
GROUP BY photos.id
ORDER BY Total_Likes DESC

