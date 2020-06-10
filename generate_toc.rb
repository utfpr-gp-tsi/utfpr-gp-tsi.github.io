data = "- title: Table of Contents\n"
data << "  links:\n"

Dir.glob("_docs/*/").sort.each do |main_dir|

    Dir.glob("#{main_dir}**").sort.each do |file|
        if file.end_with?('.md')
            begin
                File.read(file)[/title:(.*)/]
                title =  $1.strip
                data << " " * (file.split('/').count-1)*2
                data << "- title: #{title}\n"
                data << " " * (file.split('/').count-1)*2
                data << "  url: #{file.gsub("_docs", "docs").gsub(".md", "")}\n"
            rescue
                puts "Error while locating 'title' meta-tag in file: #{file}"
                puts "Aborting..."
                exit()
            end
        elsif File.directory?(file)
            children = []
            Dir.glob("#{file}/*").sort.each do |sub_file|
                if sub_file.end_with?('.md')
                    children << sub_file
                end
            end
            if children.length > 0
                data << " " * (file.split('/').count-1)*2
                data << "  children:\n"

                children.each do |c|
                    begin
                        File.read(c)[/title:(.*)/]
                        title =  $1.strip
                        data << " " * (c.split('/').count-1)*3
                        data << "- title: #{title}\n"
                        data << " " * (c.split('/').count-1)*3
                        data << "  url: #{c.gsub("_docs", "docs").gsub(".md", "")}\n"
                    rescue
                        puts "Error while locating 'title' meta-tag in file: #{c}"
                        puts "Aborting..."
                        exit()
                    end
                end
            end
        end
    end
end

File.write("_data/toc.yml", data)