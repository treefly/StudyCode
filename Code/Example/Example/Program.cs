using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Example
{
    class Program
    {
        /*
         * 一家戏剧公司，演员会参加表演。戏剧分为喜剧和悲剧。公司根据观众的规模和戏剧的类型收费。除了账单，还有volume credits，未来的折扣。
         * */
        static Invoice _invoices = new Invoice();
        static List<Play> plays = new List<Play>()
            {
                new Play() { Name= "Hamlet",type= "tragedy" },
                new Play() { Name= "As You Like It",type= "comedy" },
                new Play() { Name= "Othello",type= "tragedy" }
            };
        static void Main(string[] args)
        {
            _invoices.InitSource();
            var str= Statement(_invoices,plays);
            Console.WriteLine(str);
            Console.ReadLine();

        }
        public static string  Statement(Invoice invoice, List<Play> plays)
        {
            var totalAmount = 0;//总共数量
            var volumeCredits = 0;//用户 信用卷
            var result = invoice.Customer;//用户信息

            foreach (var perf in invoice.performances)
            {
                var thisAmount = amountFor(perf);
                volumeCredits += volumeCreditsFor(volumeCredits, perf);

                result += playFor(perf)?.Name + (thisAmount/100) + (perf.audience) + "\r\n"; ;
                totalAmount += thisAmount;
                
            }
            result += totalAmount / 100 +"\r\n";
            result += volumeCredits + "\r\n"; ;
            return result;
        }

        private static int volumeCreditsFor(int volumeCredits, Performance perf)
        {
            volumeCredits += Math.Max(perf.audience - 30, 0);
            if ("comedy" == playFor(perf)?.type) volumeCredits += perf.audience/5;
            return volumeCredits;
        }

        private static Play playFor(Performance perf)
        {
            var play = plays.FirstOrDefault(item => item.Name.ToLower().Equals(perf.playID.ToLower()));
            return play;
        }



        /// <summary>
        /// 发票金额统计
        /// </summary>
        /// <param name="perf"></param>
        /// <returns></returns>
        private static int amountFor(Performance perf)
        {
            var result = 0;
            var play = playFor(perf);
            if (play == null)
            {
               return 0;
            }
            switch (play.type)
            {
                case "tragedy"://悲剧
                    result = 40000;
                    if (perf.audience > 30)
                    {
                        result += 1000*(perf.audience - 30);
                    }
                    break;
                case "comedy"://喜剧
                    result = 30000;
                    if (perf.audience > 20)
                    {
                        result += 10000 + 500*(perf.audience - 20);
                    }
                    result += 300*perf.audience;
                    break;
                default:
                    throw new Exception(play.type);
                    break;
            }
            return result;
        }
    }


    
    /// <summary>
    /// 戏剧
    /// </summary>
    public class Play
    {
        /// <summary>
        /// 戏剧名称
        /// </summary>
        public string Name { get;   set; }
        /// <summary>
        /// 戏剧类型 喜剧还是悲剧
        /// </summary>
        public string type { get;   set; }
       
    }


    /// <summary>
    /// 发票信息
    /// </summary>
    public class Invoice
    {
        /// <summary>
        /// 用户信息
        /// </summary>
        public string Customer { get;private set; }

        /// <summary>
        /// 观看的戏剧信息
        /// </summary>
        public List<Performance> performances { get; private set; }
    
        public void InitSource()
        {
            if (performances ==null)
            {
                performances = new List<Performance>();
            }
            performances.Add(new Performance() { playID = "hamlet", audience  = 55});
            performances.Add(new Performance() { playID = "as­like", audience  = 35 });
            performances.Add(new Performance() { playID = "othello", audience = 40 });
        }
    }

    /// <summary>
    /// 表演信息
    /// </summary>
    public class Performance
    {
        /// <summary>
        /// 表演者
        /// </summary>
        public string playID   { get;  set; }
        /// <summary>
        /// 观众数
        /// </summary>
        public int audience { get;  set; }
    }
}
