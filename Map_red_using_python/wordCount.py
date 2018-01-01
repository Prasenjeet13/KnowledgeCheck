from mrjob.job import MRJob

class wordcount(MRJob):
  
    #def mapper(self,_,line):
    #    words=line.split()
    #    for word in words:
    #        yield word.lower(),1

        def mapper(self, _, line):
            (word) = line.split(' ')
            yield word, 1

        def reducer(self,x,count):
            yield x,sum(count)

if __name__ == '__main__':
    wordcount.run()
