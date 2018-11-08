

# Knowledge Technology
- [Knowledge Technology](#knowledge-technology)
    - [Basic Concepts](#basic-concepts)
    - [Document representation](#document-representation)
    - [String processing](#string-processing)
        - [Regular expression](#regular-expression)
    - [Similarity (of text documents)](#similarity-of-text-documents)
        - [Terminologies](#terminologies)
        - [TF-IDF](#tf-idf)
        - [Jaccard Similarity](#jaccard-similarity)
        - [Dice Similarity](#dice-similarity)
        - [Cosine Distance](#cosine-distance)
        - [Relative entropy (Kullback-Leibler deivergence)](#relative-entropy-kullback-leibler-deivergence)
        - [Skew divergence](#skew-divergence)
        - [Jensen-Shannon divergence](#jensen-shannon-divergence)
    - [Probability](#probability)
        - [Conditional Probability](#conditional-probability)
    - [Approx String Search](#approx-string-search)
        - [Spelling Correction](#spelling-correction)
    - [Information Retrieval](#information-retrieval)
        - [Searching](#searching)
        - [Approaches to retrieval](#approaches-to-retrieval)
        - [Boolean querying](#boolean-querying)
        - [Ranking](#ranking)
        - [Cosine with TFIDF weighting model](#cosine-with-tfidf-weighting-model)
    - [Web Search](#web-search)
        - [Add-on technologies](#add-on-technologies)
        - [Web crawler](#web-crawler)
        - [Inverted list](#inverted-list)
        - [Phrase queries](#phrase-queries)
        - [Pagerank overview](#pagerank-overview)
    - [Machine Learning](#machine-learning)
        - [Supervised](#supervised)
        - [Unsupervised](#unsupervised)
    - [Testing strategy](#testing-strategy)
        - [Bias and variance](#bias-and-variance)
    - [Evaluation Metrics](#evaluation-metrics)
        - [Information retrieval](#information-retrieval)
        - [Classification](#classification)
        - [Clustering](#clustering)
    - [Recommendation System](#recommendation-system)
        - [Content bases](#content-bases)
        - [Collaborative Filtering](#collaborative-filtering)
    - [Rule mining](#rule-mining)
        - [Approaches](#approaches)
            - [Brute-force (prohibitive)](#brute-force-prohibitive)
            - [Two-step approach](#two-step-approach)
        - [Techniques](#techniques)
            - [Apriori](#apriori)
            - [Generate Hash Tree](#generate-hash-tree)
        - [Further Issues](#further-issues)
- [Tao Lu](#tao-lu)
    - [Calculating document ranking for query](#calculating-document-ranking-for-query)
    - [Dicision Tree Select Splitting Attr](#dicision-tree-select-splitting-attr)
        - [Using IG](#using-ig)
        - [Using Gain Ratio](#using-gain-ratio)
        - [Using GINI-Splite](#using-gini-splite)
    - [Accumulator](#accumulator)
        - [Acc limiting approach](#acc-limiting-approach)
        - [Acc threshold approach](#acc-threshold-approach)
    - [Calculate Evaluation Matrics for **Classifier**](#calculate-evaluation-matrics-for-classifier)

## Basic Concepts

- **Data** Measurements
- **Information** Processed data, patterns that are satisfied for given data
- **Knowledge** Information interpretted with respect to a user's context to extend human understanding in a given area.
- **Concrete Tasks** Mechanically processing data to an unambiguous solution; Limited contribution to human understanding
- **Knowledge tasks** Data is unreliable or the outcome is ill-defined; Computers mediate between user and the data, where context is critical; Enhance human understanding



## Document representation
- **Structured data** Conforms to a schema
- **Semi-Structured data** Conforms in part to a schema
  
## String processing

### Regular expression
- \* : Zero or more
- \? : Zero or one
- \+ : One or more

They are greedy
- \{m,n\} : Between m and n inclusively
- [0-9] = \\d
- [a-zA-Z0-9] = \\w
- [\\ \\t\\r\\n\\f] = \\s
- [^0-9] = \\D
- [^a-zA-Z0-9] = \\W
- [^\\ \\t\\r\\n\\f] = \\S


Placing a pattern in parentheses leads to the match being stored as a var
- \\n : nth var





## Similarity (of text documents)

### Terminologies

- **$f_d$** number of terms in document d
- **$f_{d,t}$** Freq of term t in document d (TF)
- **$f_{ave}$** The average number of terms contained in a document
- **$N$** Number of documents
- **$f_t$** Number of documents that contains t
- **$F-t** Total number of occurrence of t across all documents
- **$n$** the number of indexed terms in the collection 


### TF-IDF
- Terms that occur frequently in a given document have high utility

$$ w_{d,t} \propto f_{d,t} $$
- Terms that occur in a wide varity of docs have low utility

$$ w_{t} \propto \frac{1}{f_t}$$

Weight up these two vectors

$$w_{d,t} = f_{d,t} \times log\frac{N}{f_t}$$

### Jaccard Similarity

$$
\frac{|A \cap B |}{|A \cup B|}
$$

### Dice Similarity

$$
\frac{2|A\cap B|}{|A| + |B|}
$$

### Cosine Distance

$$ sim(A,B) = \frac{\vec{a}\cdot\vec{b}}{|\vec{a}||\vec{b}|} $$

### Relative entropy (Kullback-Leibler deivergence)

A measure of difference between to probability distributions

$$D(X||Y) = \sum_i x_i log2\frac{x_i}{y_i}$$


### Skew divergence

$$
s_\alpha(X,Y) = D(X||\alpha Y + (1-\alpha) X)
$$

### Jensen-Shannon divergence

$$
JSD(X||Y) = \frac{1}{2}D(X||m) + \frac{1}{2}(Y||m)
$$
 
Where $m = \frac{X+Y}{2}$

## Probability

### Conditional Probability
- Sum rule
  $$ P(A) = \sum_BP(A\cap B )$$

- Multiplication rule
  $$P(A\cap B) = P(A|B)P(B)$$

- Bayes rule
  $$ P(B|A) = \frac{P(A\cap B)}{P(A)} = \frac{P(A|B)P(B)}{P(A)} $$

## Approx String Search

### Spelling Correction



- Neighbourhood search
    - Generate all variants of w that utilise at most k changes (Insertions/Deletions/Replacements)
    - Check whether generated variants exist in dictionary
    - All results found are returned
    - For k edits, $O(\Sigma^k \cdot|w|^k )$ neighbours where $\Sigma$ is alphabet size
- Global Edit distance
    - Transform the string of interest into each dictionary entry, using insert, delete, replace and match
    - How to calculate: First init the table, left top corner = 0, going along "from" cause addition of "Delete", going along "to" direction cause addition of "Insert". Go through each cell one-by-one, take max of inserting from last row, deleting from last column or match/replace from left-up cell. Last cell is the result.
- Local edit distance: This is like global edit distance, but we are searching the best substring match.
    - how to calculate: Init table, but this time first row and col as 0. Go through just like before, but max() take 0 as additional argument as well. Final result is the greatest value in the table.

- N-Gram Distance
   $$|G_n(s)| + |G_n(t)| - 2\times |G_n(s) \cap G_n(t)|$$

- Soundex
    - Except for init char, translate string chars according to the table
    - remove duplicates
    - remove 0s
    - truncate to four symbols
  


## Information Retrieval

IR is the subfield of computer science that deals with storage and retrieval of documents

Documents are not always text. They can be defined as messages: an object that conveys information from one person to another

- Stored documents are real-world objects that have been created for individual reasons without consistent format, wording, language, length
- The retrieval system is concerned with the document as originally created not with a formal representation of the document
- Users may not agree on the value of a particular document, even in relation to the same query
- Documents are rich and ambiguous
- Text in some kind of collection has structured attrs, but these are only occasionally useful for searching

### Searching

Categories of searching:
- Informational
- Factoid
- Topic tracking
- Navigational
- Transactional
- Geospatial

### Approaches to retrieval
Consider the criteria that a human might use to judge whether a document should be returned in response to a query.
- Try and guess what the query might be inspired by, and what kind of info or doc is being sought
- Consider current news and events, or their own experience with query terms
- Approach the task of looking through the docs with expectations of what a match is that is based on much more than the terms
- Be ready to consider a doc even if the terminology is completely different

### Boolean querying
Documents match if they contain the terms and don't contain the NOT terms. There is no ordering, only yes/no (Start with least frequent terms to reduce cost)

### Ranking
By looking for evidence in the document that it is on the same topic as the query

- Choose docs with words in common with query
- Choose docs with the query terms oin title
- Created recently
- Translate between languages
- Choose authoritative, reliable documents

### Cosine with TFIDF weighting model
This is nothing more than calculating the cosine distance between query the documents. The term $w_{d,t}$ and $w_{q,t}$ are just vector representation of document and query using the key terms. Sometimes they are just TF and IDF. In most cases, they are given in questions.


$$
    S(q,d) = \frac{\sum_tw_{d,t}\times w_{q,t}}{|q||d|}
$$

How to calculate?
- Remember the fucking terminology:
- N is the fucking number of documents 
- $f_t$ is the number of fucking documents which contains the fucking term
- $|q|$ and $|d|$ are the length of the god damn vector representation of the fucking query and document using given $w_{d,t} and w_{q,t}$


## Web Search
Main technological components:
- **Crawling**
- **Parsing** Translate data into canonical form
- **Indexing** Data structure build to allow search to take place efficiently
- **Querying** The data structures must be processed in response to queries


### Add-on technologies
- Snippet generation
- As-you-type querying
- Query correction
- Answer consolidation
- Info boxes
- Tokenization: reduce a webpage or a query to a sequence of tokens
- Stemming: Stripping away affixes. implemented as cascaded set of rewrite rules.
- Zoning: Web documents can usually be segmented into discrete zones such as title, anchor text, headings and so on. Calculating the weight of each zone

- Indexing:
    - **Search structure** For each word t, the search structure contains a pointer to the start of the corresponding inverted list, and a count $f_t$ of the documents containning t
    - **Inverted lists** For each word t, the inverted list contains the identifier d of documents containing t as ordinal numbers, and the associated freq $f_{d,t}$ of t in d.

- Inverted list allows for fast querying because
    - The terms in the query correspind to the search structure
    - The index only indicates documents where the term is present

- Ranked querying 

- Link analysis 
  
  A string piece of evidence for a page's importance is given by links, how many pages have links to this page

- Pagerank
  
    Use random walks to calculate the $\pi(d)$ value for page, with assumption that each page has same probability of being the start point and probabilities of visiting outgoing links are equal. 

### Web crawler
- Challenges:
    - There is no central index of URLs of interest
    - Some website return the same content as a new url at each visit
    - Some pages never return status done on access
    - Some websites are not intended to be crawled
    - Much web content is generated on-the-fly from databases, which can be costly for content provider, so excessive numbers of visits to a site are unwelcome
    - Some contents has a short lifespan
    - Some regions and content providers have low bandwidth

### Inverted list

- Search structure
    - Pointer to the start of inverted list for each term
    - A count of docs that contains t $f_t$
- Inverted list
    - d that contains t
    - Freq of t in d(We could store $w_{d,t}$ or $\frac{w_{d,t}}{W_{d\cdot}}$)
- Boolean Querying
    - Fetch inverted lists
    - Union for OR
    - Intersection for AND
    - Complement for NOT


### Phrase queries
How to find the pages in which the words occur as a phrase

Strategies:
- Process as bag of words, then post-process (Can be slow, start with most infrequent terms to speed up)
- Add position to index entries
- Use some form of phrase index of word-pair index so that they can be directly indetified without using inverted index

### Pagerank overview


## Machine Learning

### Supervised
- **Classification**
    - **Decision Tree**
        - Best split (Check out Tao Lu)
        - Parameters: Total number of nodes, depth, minimum number of data points for a split

        - How to set params? Cross-validation
        - Continuous attributes: Discretization at the beginning or find ranges by equal interval bucketing
    - **Random forest**: train multiple trees on random subset of samples, decision via majority voting (Can be subset of record, subset of attr)
        - Num of trees
        - Use bagging to come up with different training dataset for each tree
        - When building our tree, at each node, we only consider a random sample of attributes. 
    - **SVM**
        - Find hyperplane that maximises the margin (find w and b)
        - Lagrange multiplier applied to get dual problem: Solve $\alpha$
        - $x_i$ with non-zero $\alpha_i$ will be support vectors
        - Softmargin introduces parameters to tradeoff the relative importance of maximizing the margin and fitting the data
        - Use kernel function for non-linear SVM
        - One-vs-all multi-class strategy: Build M classifiers for M classes, choose class with largest margin for test data
        - One-vs-one: One classifier per pair, choose class selected by most classifiers

        How to derive
        
        Write down the margin by calculating the distance between 2 aprallel lines
        $$(b-1) + x_0w_0 + x_1w_1 + ... = 0$$
         and
        $$(b+1) + x_0w_0 + x_1w_1 + ... = 0$$ 

        Distance between parallel lines is given by 
        $$d = \frac{ax_1+by + c}{\sqrt{a^2 + b^2}}$$ 
        where $x_1$ and $y_1$ are points on one line and $ax+by+c=0$ is another line.

        Then maximize the margin using constraint optimization with Lagrange multiplier $\alpha$. Write all the parameter in form of $\alpha$, then solve the dual problem, which is dead easy.

        For soft margin, trade off the width of margin and how many points have to be moded around. The margin can be smaller than 1 for a point $x_i$ by setting $\xi_i>0$ but pay penalty of $C\xi_i$ in the minimization objective, i.e., minimize 
        $$
        w^Tw + C\sum_i\xi_i
        $$
        st
        $$
        y_i(w^Tx_i + b) >= 1-\xi_i
        $$


    - **KNN** 
  
        Select K nearest neighbours and look at their label
    - **Naive Bayes**
         $$c = argmax_cP(c)\prod P(x|c)$$

    - **NN**
        - Define E
        - Forward pass: calculate hidden $H_i$ and output $O_j$ values
        - Calculate error for each layer
        - Update weight using gradient descent
        - Until converge



  
  

### Unsupervised
- Association
- Clustering
    - **K-means**
        - Init clusters
        - Assign cluster
        - Recalculate cluster center
        - Reassign cluster ...
        - \+ Efficient
        - \+ Cane be extended to hierarchical clustering
        - \- Local minimum
        - \- Need k in advance
        - \- Unable to handle un-convex
        - \- Ill defined "mean"
        - \- Data contains outliers
    - **Buttom-up**
        - Start with single-instance clusters
        - Iteratively merge closest two
    - **Top-down**
        - Start with one 
        - Find two partitioning clusters
        - Proceed recursively on each subset
    - **Cluster dist measurement**
        - MIN (single link) use two closest points in clusters
        - MAX (complete link) Use two farthest points in clusters
        - Group average Use average dist between all points
- Reinforcement learning
- Recommender system
- Anomaly dection

## Testing strategy

### Bias and variance
- **(Training) bias** is the average distance between expected value and estimated value
- **(Testing) variance** is the standard deviation between the estimated value and the average estimated value(Inconsistency of decision)

- **Holdout** Fixed training and testing set
    - \+ Simple
    - \+ High reproducibility
    - \- Tradeoff: more training or testong
    - \- Representativeness of the training the test data
- **Random subsampling** Multiple iterations, randomly selecting training and test data
    - \+ Reduce bias and variance
    - \- Reproducability
- **Leave one out** Train N times, 1 test instance each time. Measure average performance
    - \+  No sampling bias
    - \+ Higher accuracy
    - \- Expensive
- **M-fold cross validation**
    - \+ Only train M times
    - \+ Can measure stability of the system
    - \- Sampling bias
    - \- Results varies unless partition identically
    - \- Slightly low acc
    - \- Not suitable for small dataset


- **Regression**

- **Feature Selection**
  
    To choose a subset of attributes that give best performance on the development data (Slow)

    Greedy approach: 
    - Train and eval on each single attr
    - Choose best attr
    - Repeat
        - Train and evel model on best attrs, plus each remaining single attr
        - Choose best attr out of remaining set
    - Until performance stops increasing

    Ablation approach:
    - Start with all attributes
    - Remove one, train and eval
    - Until divergence
        - From remaining attr, remove each attr, train and eval
        - Remove the attr that cause least performance degredation
    - Termination condition: Performance starts to degrade by more than $\epsilon$

    Mutual Information Approach

    $$P(A,C) = P(A)P(C)$$
    if attr independent from class. Which means 
    $$P(C|A) = P(C)$$

    The equation 
    $$\frac{P(A,C)}{P(A)P(C)} = 1$$

    - If $LHS \approx 1$, almost random chance
    - If $LHS >>1$, they occur together much more often than randomly
    - If $LHS  << 1$, negatively correlated

    Therefore 
    $$PMI(A,C) = \log_2\frac{P(A,C)}{P(A)P(C)}$$

    Greatest PMI indicates best attribute valie A for class C. Taking into consideration of all the possible classes and attribute values

    $$
    MI(A,C) = \sum_{i\in{a, \bar a}}\sum_{j\in{c, \bar c}}P(i,j)PMI(i,j)
    $$
  
## Evaluation Metrics

- **Generalise** when it learns the target function well, rather than specifics of the training set.
- **Overfitting** when the classifier fails to generalise(describe training set very well, but does not describe the test data well)

### Information retrieval
- **Precision** Fraction of correct responses among attempted responses
- **Recall** Proportion of words with a correct response
- **Precision at k(P@k)** Fraction of number of returned relevant results in top k
- **Average Precision** 
    A single number that characterizes the performance instead of comparing curves.

    This is basically integrating precision pver recall from 0 to 1. Descretize the calculation to single samples to get the following form:

  $$AP=\frac{1}{R}\sum_{k|d(k)isrelevent}P@k$$
  Where R is total num of relevant docs for query
  
### Classification
- **Accuracy** Proportion of correctly classified instance among all instances
  $$ACC=\frac{TP + TN}{TP + FP + TN + FN}$$

- **Error Rate** 1-ACC
- **Error Rate Reduction**
  $$ERR = \frac{ER_0-ER}{ER_0}$$
  where $ER_0$ is baseline ER
- **Precision** Proportion of correct positive predictions
  $$Precision=\frac{TP}{TP + FP}$$
- **Recall** Proportion of correctly predicted positive instances among all actual positive instances
- **Specificity** Proportion of correctly predicted negative instances among all actual negative instances.
- **F-score** Gives an overall performance
  $$Fscore = (1+\beta^2)\frac{PR}{R + \beta^2P}$$
- **ROC(Receiver Operating Characteristics)** Best prediction yields upper left corner.
- **AUC(Area Under the Curve)** Probability that a classifier will rank a randomly chosen instance higher than a randomly chosen negative one.
- **Micro-averaging** Summing up numerator and denominator for each class
- **Macro-averaging** Summing up the results then divide by number of classes


### Clustering  
- **Unsupervised** Check the cohesion and separation of the clusters.
- **Supervised** Compare the cluster structure with external structure. For example entropy in a cluster is the measurement of the purity of instances.
- **Relative** Compares different clusterings with either unsupervised or supervised evaluation strategy.
- **SSE** Sum of squared error. Sum of the square of distance of each instance to the center of cluster for all the clusters.




## Recommendation System

### Content bases
- Can recomment new items
- Feature extraction can be difficult

### Collaborative Filtering
- **User-based** Similar users have similar ratings on the same item.
    - Identify set of items rated by the target user
    - Identify other users rated at least 1 items in this set
    - Compute how similar each neighbor is to the target user
    - Select k most similar neighbors
    - Predict ratings for the target user's unrated items
    - Recommend to the user top N products based on predicted rating


    User Similarity (Pearson correlation)
    $$
    r(X,Y) = \frac{\sum_{i}(X_i-\bar X)(Y_i -\bar Y)}{\sqrt{\sum_i(X_i-\bar X)^2}\sqrt{\sum_i(Y_i-\bar Y)^2}}
    $$

    Predicted ratings

    $$
    r^*_{uj} = \mu_u + \frac{\sum_{v\in P_u(j)}Sim(u,v)\cdot(r_{vj} - \mu_v) }{\sum_{v\in P_u(j)}|Sim(u,v)|}
    $$



- **Item-based** Similar items are rated in a similar way by the same user
    - Identify set of users who rated the target item i
    - Identify which other items were rated 
    - Compute similarity between each neighbour and target item
    - Select k most similar neighbours
    - Predict ratings for the target item


## Rule mining

- **Itemset** is a collection of one or more items, like {A,B,C}. 

- **k-itemset** contains k items.
- **Support count** ($\sigma$) is freq of occurrance of itemset
- **Support** is fraction of transactions that contain an itemset
- **Frequest Itemset** is an itemset whose support is greater than or equal to a minsup threshold
- Association Rule
  An implication expression of form $A \rightarrow B$ where A and B are itemsets
  - Support: Fraction of transactions that contain both A and B
  $$s(A\rightarrow B) = \frac{\sigma(A\cup B)}{\sigma(*)}$$
  - Confidence: Measure how often item in A appear in transactions that contain B
  $$c(A\rightarrow B) = \frac{\sigma(A\cup B)}{\sigma(A)}$$

  - Useful: High quality, actionable information
  - Trivial: Already known to anyone familiar with the context
  - Inexplicable: This which have no apparent explanation
  
### Approaches

#### Brute-force (prohibitive)
- List all possible rules
- Compute support and confidence
- Prune rules that fail the minsup and minconf

#### Two-step approach
- Frequent itemset generation
    - Reduce candidate (Apriori)
    - Reduce transaction
    - Reduce number of comparisons
- Rule generation (Generate Hash Tree)

### Techniques
#### Apriori
Subset always have higher support

- Let k=1
- Generate frequent itemsets of length 1
- Repeat until no new frequent itemsets are identified
    - Prune candidate itemsets containing subset of length k that are infreq
    - Count support of each candidate by scanning database
    - Eliminate infreq candidates
    - Generate length k+1 candidate itemsets from length k itemsets 

#### Generate Hash Tree

Accelerates counting support count for candidates

- Build up an hashtree by hashing items in candidate itemsets
- Given a transaction, start from 1th layer, recursively:
    - At $k^{th}$ layer, hash $k^{th}, k+1^{th}...k+n^{th}$ items at current node, until the leaf of the tree. Then Compare the transaction with candidates at leaf node.

### Further Issues
- Correlation vs causation
    - May be wrong direction
    - Causation with unseen intermediary
    - Unseen cause of both events
    - Coincidental
- Data mining 
    - Valid: Data has support for the pattern
    - Non-trivial: The pattern isn't self-evident from the data
    - Previously unknown


# Tao Lu

## Calculating document ranking for query

- Write vector of documents using given tf formula
- Write vector of queries using given idf formula. Pay attention that when the freq of term in query is zero, the value should probabily be 0
- Calculate the similarity

## Dicision Tree Select Splitting Attr

### Using IG
 - Calculate the root entropy using class distribution $P(C)$
 - For each attribute A, calculate:
    - Entropy of $P(C)$ for the data subset separated by different A values.
    - Sum up the entropies with weight (attr A value count distribution) as H(A)
    - Calculate IG(A) by subtracting from H(R)

### Using Gain Ratio
   - Gain ratio is obtained by dividing IG using SI
   - SI (Split information) is the entropy of attr count distribution

### Using GINI-Splite

- Calculate GINI(R)
- Calculate weighted sum of GINI of different values of the attr
- Substract to get GS value of the attr

GINI is the 1- sum of probability square

## Accumulator
- Init accumulator for each doc
- For each query term t
    - Add weight product $w_{q,t}w_{d,t}$ to corresponding accumulator for doc in inverted list
- Take max

### Acc limiting approach
Limiting the size of accumulators, if hit the limit, stop creating accumulators. (order query terms by $w_{q,t}$)

### Acc threshold approach
If inner prod is smaller than threshold, do not create accumulator.(order query terms by $w_{q,t}$)


## Calculate Evaluation Matrics for **Classifier**
- Look at the confusion matrix, the diagonal elements are correctly classified item counts.
- Accuracy is calculated once per classification, summing up diagonal divided by total item count
- Precision and Recall are calculated once per class. The sum along actual except the diagonal element of a class is FN(because they are incorrect, and negative). Sum along classified except diagonal ones is FP because they are incorrect, and should be positive
- Then use the formula to calculate the god damn values

