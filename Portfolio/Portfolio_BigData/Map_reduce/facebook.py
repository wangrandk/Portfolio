from mrjob.job import MRJob
from mrjob.step import MRStep
import re

#WORD_RE = re.compile(r"[\w']+")


class facebook(MRJob):

    def steps(self):
        return [
            MRStep(mapper=self.mapper_one,
                   combiner=self.mapper_two,
                   reducer=self.combine_keys)  , 
            MRStep(combiner=self.intersect_values)
        ]

    def mapper_one(self, _, line):       
        yield (line.split()[0], line.split()[1])
        yield (line.split()[1], line.split()[0])
        
    def mapper_two(self, word, counts):      
        digits = [(x) for x in (counts) ]
        #yield word,digits
        for i in range(len(digits)):
            f1 = digits[i]
            if word < f1: 
                yield (word, f1), digits
            else: 
                yield (f1, word), digits
                
        for j in range(i + 1, len(digits)):
                f2 = digits[j]
                if f1 < f2:
                    yield (f1, f2), digits
                else:
                    yield (f2, f1), digits
            

    def combine_keys(self, key, value):
       yield tuple(key), tuple(value)
        
    def intersect_values(self, word, counts):
        c = list(counts.next())
        
        if len(c) <= 2:
           for i in range(len(c)): 
              if i < len(c)-1:
                yield word, list((set(c[i])) & (set(c[i+1])))
        if len(c) <=4:
           for i in range(len(c)): 
              if i < len(c)-2:
                yield word, list((set(c[i])) & (set(c[i+1])) & (set(c[i+2])))
         #print c[i],c[i+1]
           
if __name__ == '__main__':
    facebook.run()

