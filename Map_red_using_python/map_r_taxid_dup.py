from mrjob.job import MRJob
from mrjob.job import MRStep

class xyz(MRJob):

    def steps(self):
        return [
            MRStep(mapper=self.mapper,
                   reducer=self.reducer),
            MRStep(mapper=self.r_output)
            ]

    def mapper(self,_,line):
        (uid,tid,lid,x,y,z)=line.split(',')
        yield uid,1

    def reducer(self,uid,count):
        #yield None,(sum(count),uid)->1
        yield uid,sum(count)

    def r_output(self,uid,s_count):
        if(s_count>1):
            yield uid,s_count
        #yield max(s_count)->2 # This may give a result like 3    "ITE0002331" when used with 1.  And in that scenario this func will be a reducer in MRStep.


if __name__ == '__main__':
    xyz.run()
