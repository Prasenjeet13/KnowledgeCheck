from mrjob.job import MRJob
from mrjob.job import MRStep
import re

regex=re.compile(r"[\w']+")

class wordcount(MRJob):

    def steps(self):
        return [
            MRStep(mapper=self.mapper_get,
                   reducer=self.reducer_count),
            MRStep(mapper=self.mapper_make_count_key,
                   reducer=self.r_output)
            ]
    
    def mapper_get(self,_,line):
        words=regex.findall(line)
        for word in words:
            yield word.lower(),1

    def reducer_count(self,x,count):
        yield x,sum(count)

    def mapper_make_count_key(self,word,count):
        #yield '%04d'%int(count), word
        yield '%d'%int(count), word

    def r_output(self,count,words):
        for word in words:
            yield count,word

if __name__ == '__main__':
    wordcount.run()
