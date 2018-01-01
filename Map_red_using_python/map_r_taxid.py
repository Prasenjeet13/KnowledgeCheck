from mrjob.job import MRJob

class xyz(MRJob):

    def mapper(self,_,line):
        (uid,tid,lid,x,y,z)=line.split(',')
        if(lid=='H'):
            tid=tid[1:3]+'-'+lid+'-'+tid[3:]
            #yield uid,tid #to generate values only with lid as 'H'
        yield uid,tid


if __name__ == '__main__':
    xyz.run()
