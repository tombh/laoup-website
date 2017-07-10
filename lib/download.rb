# Don't forget to de-dupe sub files cos of Mouse's #Throwbacks
class DownloadVideoMeta
  def download
    `youtube-dl \
       -o 'tmp/%(id)s__%(upload_date)s'
       --write-sub
       --skip-download
       --ignore-errors
       https://www.youtube.com/user/laoshu505000`
  end
end
