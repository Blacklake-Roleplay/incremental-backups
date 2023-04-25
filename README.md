# Incremental backups
A simple script that does an incremental backup every x

## Why
I had a need of wanting to create a small, lightweight backup for a Project Zomboid server. 
By default, the game offers a hard clone every x mins, which is the standard with most games. This is fine up until your world map becomes multiple GB big, where frequent backups might be infesable, or the cpu + disk speed might harm the actual server.

My ''work'' around to this problem is this little script. Every x mins, it will scan the important folder and only copy anything that has been modified in the last x mins

This allows for frequent small backups, saving both disk space and resources

This does have its downside:
- Only works on programs that write to disk (Some may only save on exit)
- Missing an incremental backup will result in the whole backup being invalid (in most cases)
- Rolling back requires us to roll all the incremental backups up

## How to use?
(todo)
