# Test result
IT_Junior_task01_with_restrictions_v04

### Выполнил Беляев Борис belbor1@gmail.com

#### Описание
В dockerfile представлен контейнер на базе ubuntu 18.04 с программами htslib, libdeflate, samtools, biobambam2.
В коммите eaa2655a7b2c75ee49cdf515985c19d1f329a01f представлен контейнер с samtools, который успешно собирается средствами docker.
Последние изменения в ветке master не протестированы.
Для samtools установлена программа htslib, для htslib - libdeflate. Программы собраны и установлены в директорию /soft

Zlib был установлен отдельно в свою дирректорию для libmaus2 (нужен для biobambam2), однако libmaus выдает ошибку:
    
    Required library zlib not found

Предприняты попытки устранить проблему. В частности прописаны переменные среды при сборке libmaus2 для доступа к библиотекам zlib:
    
    ./configure CPPFLAGS=-I{SOFT}/zlib_1.2.11/include  LDFLAGS=-L{SOFT}/zlib_1.2.11/lib  --prefix=${SOFT}/libmaus2_2.0.750

Однако ошибка стабильно повторяется. 
В последних коммитах слои zlib, libmaus2 и biobambam2 закомментированы.

#### Установка
Чтобы установить контейнер создайте директорию и установите в неё репозиторий git:
    
    git init 
    git remote add origin https://github.com/localghost32/test.git
    git pull https://github.com/localghost32/test.git master
    
Далее соберите образ из dockerfile и запустите его в интерактивном режиме:

    docker build -t ${your_tag} - < dockerfile
    docker run -it ${your_tag} bash
