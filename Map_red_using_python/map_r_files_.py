from mrjob.job import MRJob

class MRMaxTemp(MRJob):

    def MakFah(self, tenthsofCelcius):
        cel=float(tenthsofCelcius)/10.0
        fah=cel*1.8+32.0
        return fah

    def mapper(self,_,line):
        (loc,date,typ,data,x,y,z)=line.split(',')
        if(typ == 'TMIN'):
            temp=self.MakFah(data)
            yield loc,temp

    def reducer(self,loc,temp):
        yield loc,min(temp)

if __name__ == '__main__':
    MRMaxTemp.run()
