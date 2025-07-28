import arrow

now = arrow.now()
print(now.format('YYYY-MM-DD HH:mm:ss'))
print(now.humanize())  

print(now.to('Asia/Kolkata'))


dt = arrow.get('2024-07-28T10:30:00', 'YYYY-MM-DDTHH:mm:ss')
print(dt.shift(days=+2).format('dddd, MMMM D'))
