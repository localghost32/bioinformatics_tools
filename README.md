# test
IT_Junior_task01_with_restrictions_v04
### Выполнил Беляев Борис belbor1@gmail.com
В dockerfile представлен контейнер на базе ubuntu 18.04 с программами htslib, libdeflate, samtools, biobambam2.
В коммите eaa2655a7b2c75ee49cdf515985c19d1f329a01f представлен контейнер с samtools, который успешно собирается средствами docker.
Zlib был установлен для libmaus2, однако libmaus выдет ошибку: 

  Required library zlib not found
