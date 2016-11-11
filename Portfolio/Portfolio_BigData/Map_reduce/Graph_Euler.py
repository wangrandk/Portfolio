
from mrjob.job import MRJob
from mrjob.step import MRStep
import re

#WORD_RE = re.compile(r"[\w']+")


class Graph_Euler(MRJob):

    def steps(self):
        return [
            MRStep(mapper=self.mapper_get_words,
                   combiner=self.combiner_count_words,
                   reducer=self.reducer_count_words)
            #MRStep(reducer=self.reducer_find_max_word)
        ]

    def mapper_get_words(self, _, line):
        # yield each word in the line
        #for word in re.findall(r"[\w]+",line):
        
        x=line.split()
        #y=line.split()
        #[x for i, x in enumerate(line) if i==0]
        for word in x:
            yield (word, 1)

    def combiner_count_words(self, word, counts):
        # optimization: sum the words we've seen so far
        yield (word, sum(counts))

    def reducer_count_words(self, word, counts):
        # send all (num_occurrences, word) pairs to the same reducer.
        # num_occurrences is so we can easily use Python's max() function.
        #if sum(counts)%2 ==0:
         #  yield None 
        
        if sum(counts)%2 !=0:
           yield None, (word,1)
        #else: yield None
          
           #yield "the vertices are even",(word)
           # if all the v is even,it appears even times in the graph,  don't yield, the graph is 
           # Euler circuit, otherwise, if at least one v appears odd times, meaning the v is a 
           # has odd degree, we yield it, and the graph is not Euler circuit. 1,3,4 yes.  2,5 no.


if __name__ == '__main__':
    Graph_Euler.run()

