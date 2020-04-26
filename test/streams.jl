struct Normal{T} end
struct Exponential{T} end

const STREAMS = Dict{DataType,Dict{Int,Vector}}(
    UInt64 => Dict(
        0 => [0x45a31efc5a35d971, 0xc6106997913e7a3b, 0x949e7d1a64224226,
              0x233c600f92647349, 0x275e265b37c53f51, 0x7eb1431760d5e0d9,
              0x75a91e49d501684d, 0x2eb2f990c5bd12e0, 0xdf459aadbb8c0b08,
              0xcb81434944438ad0, 0x5385088560aef3b0, 0x0702607d43845765],
        1 => [0xd0e95cf50ea18c53, 0x52313cc6b3bb6eb2, 0xbddb774f2c66c674,
              0x69b5202eb72d59db, 0x761a7311a74fbdf5, 0x7c13c9462281a28d,
              0x60fb5add7f0438e8, 0x8c18ecb2513738a0, 0x9dd0d00932a42118,
              0x6283c9dbcccaa072, 0xfa8f1990220cdb11, 0x15072177ca8d0630],
        2^32 => [0xfa0ed1dea67579f2, 0xe88d5e0e5b8b40fe, 0x5ce30167dd0c0c22,
                 0x480546a1a865a818, 0x96e8a4ff013c8a92, 0x405d04cb572b978f,
                 0x1fabeee4affbf0c3, 0xba2d1f50e67a63d0, 0x565db0bdf8d96d6b,
                 0x540858ead6088e6d, 0x14e2efe6ac5775fa, 0x8e0b0f48316d364b],
        typemax(Int64) =>
        [0xe07cb1442060b16b, 0x9f15f9ca1910888d, 0x27d667e3a5597f5e,
         0xe7c43a5819b14e87, 0xbd5d7f453bf3bc1b, 0x7c7998438141ee3f,
         0xf7d425f171d5da47, 0xe1abaee77149b9c0, 0x3f6116840ff765f4,
         0xfd613e850d5b6198, 0x524f389f5079bcf4, 0x6ff20ef5be83190b]),
    Float64 => Dict(
        0 =>
        [0.1950648807374728566, 0.0257793115230373626, 0.9055427466847816298,
         0.7734523504688743944, 0.8843643358740858051, 0.0788797171244850492,
         0.5698946304824119568, 0.1859290813601361946, 0.3502633405739192795,
         0.0789272944027068490, 0.3145803238578359639, 0.1485569608098213922,
         0.2545598088968246131, 0.0483571631942767421, 0.0070413465271252917,
         0.0508483589802035673, 0.8724974721884621864, 0.1605102180246753551,
         0.5840743840364566175, 0.4382718269681136202, 0.9528405584114081339,
         0.2329044092861747294, 0.5859153544674560176, 0.8064312206579657971],
        1 =>
        [0.5851946422124185698, 0.0773379345691123099, 0.7166282400543453334,
         0.3203570514066231833, 0.6530930076222578595, 0.2366391513734555918,
         0.7096838914472360926, 0.5577872440804085840, 0.0507900217217578386,
         0.2367818832081209912, 0.9437409715735081139, 0.4456708824294643989,
         0.7636794266904740613, 0.1450714895828306705, 0.0211240395813758752,
         0.1525450769406111462, 0.6174924165653870034, 0.4815306540740260654,
         0.7522231521093702966, 0.3148154809043408608, 0.8585216752342246238,
         0.6987132278585241884, 0.7577460634023684971, 0.4192936619738978354],
        Int64(2)^32 =>
        [0.9262377264309376024, 0.8354629112182574424, 0.1878431925440584571,
         0.3297440126430100094, 0.5402822540569656162, 0.8136704831208338984,
         0.7458235620861592974, 0.8201455119180884878, 0.8556499214817800958,
         0.5217083321266742235, 0.1835695964904275890, 0.6912309580542508325,
         0.4303038831150767241, 0.9418660572220058924, 0.1146544263022086785,
         0.8013346510146608370, 0.6567284985579240342, 0.3401312026411986711,
         0.3199271240192740340, 0.6107096843461274904, 0.3115926468885286127,
         0.1895431852488782543, 0.9098590120021339267, 0.2050781237987520100],
        typemax(Int64) =>
        [0.7932778610948740816, 0.3734837512097641809, 0.4003635844200839066,
         0.2642441753022539696, 0.8435718862417675989, 0.5996737527010649326,
         0.2592634627050232065, 0.7302011895477420466, 0.0679970382392385275,
         0.0777636071926277594, 0.9513238090110549549, 0.1286523286704006618,
         0.3620349797067561326, 0.2187559397428240348, 0.1208698967929713319,
         0.1413011948896074621, 0.5101784014171362180, 0.1411332235862896578,
         0.8650217525819665631, 0.5771692253821305573, 0.7376248001192464709,
         0.1897371938050098627, 0.8431170858467222917, 0.0142466392990996393]
    ),
    Normal{Float64} => Dict(
        0 =>
        [-0.381111861786743722, -0.020452508120591215, +0.610788422210481796,
         -1.385748932245142839, -1.611731486297559135, -0.110517958623616241,
         -0.503001669385000350, +0.265474785013935066, +0.547305897889466042,
         +0.108473227118974030, +0.718753376471714445, -0.282678969833291605,
         +0.736726902332106914, -0.134961030673573013, +0.006949743869390782,
         +0.077725160632003479, +0.510076650626809736, -0.426360569496689379,
         +0.908664368119342147, -0.730524759144574709, -1.232581867613880222,
         +0.398240840524731410, -1.139673658738002970, -0.821968503141728313],
        1 =>
        [-0.532520074864123116, +0.098465514284785005, +0.752886522124523450,
         -0.843537403874254577, -2.013829355631106655, -0.269807641197127135,
         +1.032293472303989157, +0.675566099119190633, +0.082160827543964254,
         +0.246926640359151073, -1.500529147318949708, +0.328632009212124654,
         -1.853198706543207619, -0.337190826546952760, +0.035662516379140363,
         +0.232143558890440915, +0.556345368618102021, -1.027821009268467423,
         +1.206403573149015029, -0.620592199441276415, +0.612308205879786516,
         +1.491394429348988471, -0.675799668973327217, -0.751223710193982930],
        Int64(2)^32 =>
        [+2.804497592250339011, +1.277061645230312958, +0.121477387690437907,
         +0.187076393406817809, +0.627670131300367640, -1.703321215824013413,
         -0.989982760767698200, +2.075029846471020178, -1.649703602248066669,
         -0.531759939161147721, +0.609495986040443971, -0.603631997036122026,
         -0.684174512146213942, +0.534356647282485442, -0.092174031696126188,
         -1.285167816972012433, +0.999411412925283571, -0.499305278581140211,
         -0.091555014119427833, -1.350741201226236088, +0.482633667214938111,
         -0.377021488481488309, +0.463503407362597097, +0.397140231988096948],
        typemax(Int) =>
        [-1.529449500521834260, -0.425833043072113893, +0.751955071680120102,
         -0.295503514518007215, -0.493166268112920858, -0.488318336729492652,
         -0.221460042280709618, +1.749374475915582039, +0.209670644309441018,
         +0.166809441113434515, +1.422070714069686215, -0.201905699115775966,
         +0.792459370505811722, -0.300645840135806364, +0.220282309568965884,
         +0.117923668733925277, +0.786760475994732755, -0.098886664279309366,
         +1.136538822658988090, -1.629277960475042697, -1.097667207947351953,
         +0.316259702942887966, -1.604310346528319942, -0.027958930823246426],
    ),
    Exponential{Float64} => Dict(
        0 =>
        [+0.290443376756253313, +0.023107801871801649, +0.602445039808046201,
         +0.809080223295992051, +1.000988927033177101, +0.264416567316517359,
         +0.620552542494976045, +0.670911854378504646, +0.088847225724062964,
         +0.242968221532827683, +0.747559288415950429, +0.200756450113355078,
         +1.069994735701830679, +0.189708173540399205, +0.009436464636036371,
         +0.352940169680237725, +0.455343388287083484, +0.560636133492580124,
         +0.124215981573885054, +0.296580109076140352, +2.424871194870999336,
         +0.186103706973448774, +0.858731419298913834, +1.163246417195959559],
        1 =>
        [+0.674990107171162257, +0.186569786854466957, +1.092357077170384105,
         +1.095860857333019078, +3.225480781007138642, +0.435163300108867002,
         +2.820713900366846882, +1.177949909079809343, +0.025211559614314250,
         +0.355336719748536645, +0.378642730871126820, +0.346359637424302036,
         +2.138641751151649562, +0.363542010086324974, +0.015483132528467234,
         +0.937262071676046249, +0.692276643844622619, +0.952454488432565638,
         +0.333481484835768782, +0.483612444263148922, +0.629264342409806110,
         +1.372023120746223457, +0.841369485855095078, +0.438607768727813097],
        Int64(2)^32 =>
        [+4.301903604378438217, +5.798976162863313633, +0.116262999011904108,
         +0.163680985957347869, +1.030481683072774768, +1.518325010610733328,
         +2.054668731968426698, +2.524719717518081552, +1.214564758793303501,
         +0.752544460856171993, +1.040180627988793294, +0.737862246265513999,
         +0.172644234291837201, +0.467531051284808818, +0.105231573151698218,
         +0.366119257230970885, +4.035048035845405501, +1.451422316778351984,
         +0.060772937253374834, +1.337722289946995380, +0.051452552989185357,
         +0.300272614348955136, +0.378059311825467925, +0.293455165778313376],
        typemax(Int) =>
        [+1.126029828119699872, +0.686811209261761424, +0.509836696167542347,
         +0.464964296843861813, +0.450819900116565198, +0.563226973228172834,
         +0.265664126146503754, +1.963481563365191640, +0.328625588378420153,
         +0.154936598094436634, +4.597690643152912315, +0.039603426460420012,
         +0.764555080732192693, +0.679541058538978282, +0.135508395324274611,
         +0.137243906430860846, +0.053486342196888477, +0.101871384862385714,
         +2.289254085681110773, +2.324958005392129046, +3.492832668884421121,
         +0.126229525545209859, +1.139368981849247842, +0.021547655127562688],
    ),
    Float32 => Dict(
        0 =>
        [0.420698285102844f0, 0.488105177879333f0, 0.267643690109253f0,
         0.784768223762512f0, 0.540994763374329f0, 0.670924305915833f0,
         0.010995507240295f0, 0.477138519287109f0, 0.094086647033691f0,
         0.527673721313477f0, 0.366811752319336f0, 0.033917069435120f0,
         0.760983943939209f0, 0.305844187736511f0, 0.131725788116455f0,
         0.859405279159546f0, 0.611514329910278f0, 0.136226296424866f0,
         0.233490705490112f0, 0.448277354240417f0, 0.584921956062317f0,
         0.622289896011353f0, 0.707746386528015f0, 0.899915337562561f0],
        1 =>
        [0.262094855308533f0, 0.464315652847290f0, 0.802931308746338f0,
         0.354304671287537f0, 0.622984528541565f0, 0.012773156166077f0,
         0.032986640930176f0, 0.431415557861328f0, 0.282259941101074f0,
         0.583021402359009f0, 0.100435376167297f0, 0.101751327514648f0,
         0.282951951026917f0, 0.917532801628113f0, 0.395177364349365f0,
         0.578216075897217f0, 0.834543228149414f0, 0.408678889274597f0,
         0.700472354888916f0, 0.344832062721252f0, 0.754765987396240f0,
         0.866869688034058f0, 0.123239398002625f0, 0.699746251106262f0],
        Int64(2)^32 =>
        [0.917783975601196f0, 0.087920904159546f0, 0.094120264053345f0,
         0.794192314147949f0, 0.472978830337524f0, 0.340562701225281f0,
         0.968284964561462f0, 0.956171035766602f0, 0.698651671409607f0,
         0.066846489906311f0, 0.683287858963013f0, 0.853219389915466f0,
         0.165132641792297f0, 0.122622489929199f0, 0.413703560829163f0,
         0.907442688941956f0, 0.957183361053467f0, 0.961637139320374f0,
         0.845764756202698f0, 0.202137589454651f0, 0.507538318634033f0,
         0.727950215339661f0, 0.565004587173462f0, 0.355084896087646f0],
        typemax(Int64) =>
        [0.755414366722107f0, 0.129167199134827f0, 0.699199438095093f0,
         0.385208964347839f0, 0.904178023338318f0, 0.515083193778992f0,
         0.670723795890808f0, 0.575981140136719f0, 0.932798862457275f0,
         0.713915824890137f0, 0.951078891754150f0, 0.024201750755310f0,
         0.731067657470703f0, 0.875146985054016f0, 0.724588394165039f0,
         0.367073297500610f0, 0.651520013809204f0, 0.460271239280701f0,
         0.208518743515015f0, 0.409237980842590f0, 0.153837561607361f0,
         0.278416395187378f0, 0.801312088966370f0, 0.233442664146423f0],
    ),
    Normal{Float32} => Dict(
        0 =>
        [-0.38111186027527f0, -0.02045250870287f0, +0.61078840494156f0,
         -1.38574898242950f0, -1.61173152923584f0, -0.11051795631647f0,
         -0.50300168991089f0, +0.26547479629517f0, +0.54730588197708f0,
         +0.10847322642803f0, +0.71875339746475f0, -0.28267896175385f0,
         +0.73672688007355f0, -0.13496102392673f0, +0.00694974372163f0,
         +0.07772515714169f0, +0.51007664203644f0, -0.42636057734489f0,
         +0.90866434574127f0, -0.73052477836609f0, -1.23258185386658f0,
         +0.39824083447456f0, -1.13967370986938f0, -0.82196849584579f0],
        1 =>
        [-0.53252005577087f0, +0.09846551716328f0, +0.75288653373718f0,
         -0.84353739023209f0, -2.01382946968079f0, -0.26980763673782f0,
         +1.03229343891144f0, +0.67556607723236f0, +0.08216083049774f0,
         +0.24692663550377f0, -1.50052917003632f0, +0.32863199710846f0,
         -1.85319864749908f0, -0.33719083666801f0, +0.03566251695156f0,
         +0.23214356601238f0, +0.55634534358978f0, -1.02782106399536f0,
         +1.20640361309052f0, -0.62059217691422f0, +0.61230820417404f0,
         +1.49139440059662f0, -0.67579966783524f0, -0.75122368335724f0],
        Int64(2)^32 =>
        [+2.80449748039246f0, +1.27706170082092f0, +0.12147738784552f0,
         +0.18707638978958f0, +0.62767010927200f0, -1.70332121849060f0,
         -0.98998278379440f0, +2.07502985000610f0, -1.64970362186432f0,
         -0.53175991773605f0, +0.60949599742889f0, -0.60363197326660f0,
         -0.68417453765869f0, +0.53435665369034f0, -0.09217403084040f0,
         -1.28516781330109f0, +0.99941140413284f0, -0.49930527806282f0,
         -0.09155501425266f0, -1.35074114799500f0, +0.48263368010521f0,
         -0.37702149152756f0, +0.46350342035294f0, +0.39714023470879f0],
        typemax(Int) =>
        [-1.52944946289063f0, -0.42583304643631f0, +0.75195509195328f0,
         -0.29550352692604f0, -0.49316626787186f0, -0.48831832408905f0,
         -0.22146004438400f0, +1.74937450885773f0, +0.20967064797878f0,
         +0.16680943965912f0, +1.42207074165344f0, -0.20190569758415f0,
         +0.79245936870575f0, -0.30064582824707f0, +0.22028231620789f0,
         +0.11792366951704f0, +0.78676044940948f0, -0.09888666123152f0,
         +1.13653886318207f0, -1.62927794456482f0, -1.09766721725464f0,
         +0.31625971198082f0, -1.60431039333344f0, -0.02795893140137f0],
    ),
    Exponential{Float32} => Dict(
        0 =>
        [+0.29044339060783f0, +0.02310780249536f0, +0.60244506597519f0,
         +0.80908024311066f0, +1.00098896026611f0, +0.26441657543182f0,
         +0.62055253982544f0, +0.67091184854507f0, +0.08884722739458f0,
         +0.24296821653843f0, +0.74755930900574f0, +0.20075644552708f0,
         +1.06999468803406f0, +0.18970817327499f0, +0.00943646486849f0,
         +0.35294017195702f0, +0.45534339547157f0, +0.56063616275787f0,
         +0.12421598285437f0, +0.29658010601997f0, +2.42487120628357f0,
         +0.18610370159149f0, +0.85873144865036f0, +1.16324639320374f0],
        1 =>
        [+0.67499011754990f0, +0.18656978011131f0, +1.09235703945160f0,
         +1.09586083889008f0, +3.22548079490662f0, +0.43516328930855f0,
         +2.82071399688721f0, +1.17794990539551f0, +0.02521155960858f0,
         +0.35533672571182f0, +0.37864273786545f0, +0.34635964035988f0,
         +2.13864183425903f0, +0.36354202032089f0, +0.01548313256353f0,
         +0.93726205825806f0, +0.69227665662766f0, +0.95245450735092f0,
         +0.33348149061203f0, +0.48361244797707f0, +0.62926435470581f0,
         +1.37202310562134f0, +0.84136950969696f0, +0.43860778212547f0],
        Int64(2)^32 =>
        [+4.30190372467041f0, +5.79897594451904f0, +0.11626300215721f0,
         +0.16368098556995f0, +1.03048169612885f0, +1.51832497119904f0,
         +2.05466866493225f0, +2.52471971511841f0, +1.21456480026245f0,
         +0.75254446268082f0, +1.04018068313599f0, +0.73786222934723f0,
         +0.17264422774315f0, +0.46753105521202f0, +0.10523157566786f0,
         +0.36611926555634f0, +4.03504800796509f0, +1.45142233371735f0,
         +0.06077293679118f0, +1.33772230148315f0, +0.05145255476236f0,
         +0.30027261376381f0, +0.37805929780006f0, +0.29345515370369f0],
        typemax(Int) =>
        [+1.12602984905243f0, +0.68681120872498f0, +0.50983667373657f0,
         +0.46496430039406f0, +0.45081990957260f0, +0.56322699785233f0,
         +0.26566413044930f0, +1.96348154544830f0, +0.32862558960915f0,
         +0.15493659675121f0, +4.59769058227539f0, +0.03960342705250f0,
         +0.76455509662628f0, +0.67954105138779f0, +0.13550838828087f0,
         +0.13724391162395f0, +0.05348634347320f0, +0.10187138617039f0,
         +2.28925418853760f0, +2.32495808601379f0, +3.49283266067505f0,
         +0.12622952461243f0, +1.13936901092529f0, +0.02154765464365f0],
    ),
    Float16 => Dict(
        0 =>
        Float16[0.360351563, 0.557617188, 0.537109375,
                0.821289063, 0.829101563, 0.211914063,
                0.075195313, 0.718750000, 0.757812500,
                0.703125000, 0.921875000, 0.848632813,
                0.980468750, 0.475585938, 0.097656250,
                0.248046875, 0.525390625, 0.965820313,
                0.755859375, 0.288085938, 0.680664063,
                0.798828125, 0.858398438, 0.106445313],
        1 =>
        Float16[0.081054688, 0.673828125, 0.613281250,
                0.463867188, 0.489257813, 0.637695313,
                0.226562500, 0.156250000, 0.273437500,
                0.111328125, 0.766601563, 0.546875000,
                0.942382813, 0.428710938, 0.292968750,
                0.746093750, 0.578125000, 0.897460938,
                0.269531250, 0.864257813, 0.042968750,
                0.396484375, 0.577148438, 0.321289063],
        Int64(2)^32 =>
        Float16[0.486328125, 0.248046875, 0.033203125,
                0.023437500, 0.642578125, 0.889648438,
                0.190429688, 0.953125000, 0.354492188,
                0.606445313, 0.494140625, 0.573242188,
                0.766601563, 0.523437500, 0.059570313,
                0.770507813, 0.246093750, 0.731445313,
                0.504882813, 0.911132813, 0.753906250,
                0.368164063, 0.517578125, 0.855468750],
        typemax(Int64) =>
        Float16[0.354492188, 0.137695313, 0.841796875,
                0.631835938, 0.026367188, 0.561523438,
                0.569335938, 0.437500000, 0.488281250,
                0.398437500, 0.238281250, 0.260742188,
                0.906250000, 0.204101563, 0.828125000,
                0.064453125, 0.251953125, 0.541992188,
                0.185546875, 0.477539063, 0.237304688,
                0.787109375, 0.348632813, 0.362304688],
    ),
    Normal{Float16} => Dict(
        0 =>
        Float16[-0.381103516, -0.020446777, +0.610839844,
                -1.385742188, -1.611328125, -0.110534668,
                -0.502929688, +0.265380859, +0.547363281,
                +0.108459473, +0.718750000, -0.282714844,
                +0.736816406, -0.135009766, +0.006950378,
                +0.077697754, +0.510253906, -0.426269531,
                +0.908691406, -0.730468750, -1.232421875,
                +0.398193359, -1.139648438, -0.821777344],
        1 =>
        Float16[-0.532714844, +0.098449707, +0.752929688,
                -0.843750000, -2.013671875, -0.269775391,
                +1.032226563, +0.675781250, +0.082153320,
                +0.246948242, -1.500976563, +0.328613281,
                -1.853515625, -0.337158203, +0.035675049,
                +0.232177734, +0.556152344, -1.027343750,
                +1.206054688, -0.620605469, +0.612304688,
                +1.491210938, -0.675781250, -0.751464844],
        Int64(2)^32 =>
        Float16[+2.804687500, +1.277343750, +0.121459961,
                +0.187133789, +0.627441406, -1.703125000,
                -0.989746094, +2.074218750, -1.649414063,
                -0.531738281, +0.609375000, -0.603515625,
                -0.684082031, +0.534179688, -0.092163086,
                -1.285156250, +0.999511719, -0.499267578,
                -0.091552734, -1.350585938, +0.482666016,
                -0.376953125, +0.463623047, +0.397216797],
        typemax(Int) =>
        Float16[-1.529296875, -0.425781250, +0.751953125,
                -0.295410156, -0.493164063, -0.488281250,
                -0.221435547, +1.749023438, +0.209716797,
                +0.166870117, +1.421875000, -0.201904297,
                +0.792480469, -0.300537109, +0.220336914,
                +0.117919922, +0.786621094, -0.098876953,
                +1.136718750, -1.628906250, -1.097656250,
                +0.316162109, -1.604492188, -0.027954102],
    ),
    Exponential{Float16} => Dict(
        0 =>
        Float16[+0.290527344, +0.023101807, +0.602539063,
                +0.809082031, +1.000976563, +0.264404297,
                +0.620605469, +0.670898438, +0.088867188,
                +0.242919922, +0.747558594, +0.200805664,
                +1.070312500, +0.189697266, +0.009437561,
                +0.353027344, +0.455322266, +0.560546875,
                +0.124206543, +0.296630859, +2.425781250,
                +0.186157227, +0.858886719, +1.163085938],
        1 =>
        Float16[+0.674804688, +0.186523438, +1.092773438,
                +1.095703125, +3.224609375, +0.435058594,
                +2.820312500, +1.177734375, +0.025207520,
                +0.355224609, +0.378662109, +0.346435547,
                +2.138671875, +0.363525391, +0.015480042,
                +0.937500000, +0.692382813, +0.952636719,
                +0.333496094, +0.483642578, +0.629394531,
                +1.372070313, +0.841308594, +0.438720703],
        Int64(2)^32 =>
        Float16[+4.300781250, +5.800781250, +0.116271973,
                +0.163696289, +1.030273438, +1.518554688,
                +2.054687500, +2.525390625, +1.214843750,
                +0.752441406, +1.040039063, +0.737792969,
                +0.172607422, +0.467529297, +0.105224609,
                +0.366210938, +4.035156250, +1.451171875,
                +0.060760498, +1.337890625, +0.051452637,
                +0.300292969, +0.378173828, +0.293457031],
        typemax(Int) =>
        Float16[+1.125976563, +0.687011719, +0.509765625,
                +0.464843750, +0.450927734, +0.562988281,
                +0.265625000, +1.963867188, +0.328613281,
                +0.154907227, +4.597656250, +0.039611816,
                +0.764648438, +0.679687500, +0.135498047,
                +0.137207031, +0.053497314, +0.101867676,
                +2.289062500, +2.324218750, +3.492187500,
                +0.126220703, +1.139648438, +0.021545410],
    )
)
