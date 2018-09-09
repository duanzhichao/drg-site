defmodule DrgSite.FileService do
  #对写入文件的处理
  def write(file_path, file_name, str)do
    #临时文件是否存在
    unless(File.exists?(file_path))do
      File.mkdir(file_path)
    end
    #写文件
    {:ok, file} = File.open file_path <> file_name, [:write]
    IO.binwrite file, str
    File.close file
    #返回路径
    file_name
  end

  #对上传文件的处理
  def upload_file(file_path, conn_file) do
    %{:path => tmp_path, :filename => file_name, :content_type => content_type} = conn_file
    file_name = DrgSite.Time.stime_number() <> "_" <> file_name
    #临时文件是否存在
    if(File.exists?(tmp_path))do
      #下载目录是否存在,不存在创建,存在直接复制临时文件到下载目录
      case File.exists?(file_path) do
        true ->
          File.cp(tmp_path, file_path <> file_name)
        false ->
          file_path =
            if(File.mkdir(file_path)|>elem(0) == :error)do
              File.mkdir(System.user_home() <> "/images/")
              System.user_home() <> "/images/"
            else
              file_path
            end
          File.mkdir(file_path)
          File.cp(tmp_path, file_path <> file_name)
      end
    end
    #读取文件信息
    file_info =
      case File.stat("#{file_path}#{file_name}") do
        {:ok, result} ->
          %{path: "#{file_path}#{file_name}", #文件存放路径
            file_name: file_name, #文件名
            file_size: result.size, #文件大小
            file_type: content_type, #文件类型
            access: result.access, #文件权限
            atime: DrgSite.Time.ttime_to_stime(result.atime), #最后一次读取时间
            mtime: DrgSite.Time.ttime_to_stime(result.mtime), #最后一次修改时间
            ctime: DrgSite.Time.ttime_to_stime(result.ctime)} #创建时间
        {:error, _} ->
          %{path: "#{file_path}#{file_name}", #文件存放路径
            file_name: file_name, #文件名
            file_size: 0, #文件大小
            file_type: nil, #文件类型
            access: nil, #文件权限
            atime: nil, #最后一次读取时间
            mtime: nil, #最后一次修改时间
            ctime: nil} #创建时间
      end
    #识别文件大小
    file_size =
      cond do
        file_info.file_size < 1024 -> to_string(file_info.file_size) <> "B"
        file_info.file_size > 1024 and file_info.file_size < 1048576 -> to_string(Float.round((file_info.file_size/1024), 2)) <> "KB"
        file_info.file_size > 1048576 and file_info.file_size < 1073741824 -> to_string(Float.round((file_info.file_size/1048576), 2)) <> "MB"
        true -> to_string(Float.round((file_info.file_size/1073741824), 2)) <> "GB"
      end
    %{file_info | :file_size => file_size}
  end
end
