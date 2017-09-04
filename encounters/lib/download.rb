# Don't forget to de-dupe sub files cos of Mouse's #Throwbacks
class DownloadVideoMeta
  def self.download
    `parallel --eta -j20 youtube-dl \
       -o 'encounters/sub_files/\%\(id\)s__\%\(title\)s__\%\(upload_date\)s__' \
       --playlist-start {} \
       --max-downloads 150 \
       --write-sub \
       --skip-download \
       --ignore-errors \
       https://www.youtube.com/user/laoshu505000 \
       ::: {1..3000..150}`
  end
end
