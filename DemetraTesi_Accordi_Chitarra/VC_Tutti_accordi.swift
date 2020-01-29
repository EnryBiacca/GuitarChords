//
//  VC_Tutti_accordi.swift
//  AccordiChitarra
//
//  Created by Enrico Biacca on 20/05/18.
//  Copyright © 2018 Enrico Biacca. All rights reserved.
//

import UIKit
import AVFoundation

class VC_Tutti_accordi: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UIScrollViewDelegate {
    
    
    
    @IBOutlet weak var scrollViewGuitar: UIScrollView!
    @IBOutlet weak var fotoGuitar: UIImageView!
    
    @IBOutlet weak var PickerSelezione: UIPickerView!
    
    var BoolLblRotazione : Bool = false
    var NoteDaSuonare : [AVAudioPlayer] = []
  
    @IBOutlet weak var btn_back: UIButton!
    
    @IBOutlet weak var btn_suona_accordo: UIButton!
    
    var accordoSalvato :[Int] = []
    
    var arrPosizioniOrizzontali : [CGFloat] = [0,55,64,58,54,54,49,48,44,41,40,38,35]
    
    var NoteRiempiManico : [[String]] = [["Mi","Fa","Fa#","Sol","Sol#","La","La#","Si","Do","Do#","Re","Re#","Mi"],["La","La#","Si","Do","Do#","Re","Re#","Mi","Fa","Fa#","Sol","Sol#","La"],["Re","Re#","Mi","Fa","Fa#","Sol","Sol#","La","La#","Si","Do","Do#","Re"],["Sol","Sol#","La","La#","Si","Do","Do#","Re","Re#","Mi","Fa","Fa#","Sol"],["Si","Do","Do#","Re","Re#","Mi","Fa","Fa#","Sol","Sol#","La","La#","Si"],["Mi","Fa","Fa#","Sol","Sol#","La","La#","Si","Do","Do#","Re","Re#","Mi"]]
    
    var ArrNotePicker : [String] = ["Do","Do#","Re","Re#","Mi","Fa","Fa#","Sol","Sol#","La","La#","Si"]
    var ArrTipoAccordo : [String] = ["maggiore","minore","dim","aug","sus","6","7","maj7","9","add9","m6","m7","mmaj7","m9","11","7sus4","13","6add9","min5","7min5","7maj5","maj9"]
 
    var viewChitarra = UIView()

   // ci salvo tutte le prese che calcolo per ogni accordo
    var preseAccordi : [[Int]] = []
    
    // mi serve per comporre il manico
    var xx :CGFloat = 880
    var yy : CGFloat = 78
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = #colorLiteral(red: 1, green: 0.2681928872, blue: 0.2355245023, alpha: 0.7058005137)
        
        PickerSelezione.delegate = self
        PickerSelezione.dataSource = self
        
        scrollViewGuitar.delegate = self
        
        
        scrollViewGuitar.minimumZoomScale = 1
        scrollViewGuitar.maximumZoomScale = 1.5
        
        scrollViewGuitar.frame = CGRect(x: 0, y: 0, width: 900, height: 250)
        scrollViewGuitar.contentSize = CGSize(width: scrollViewGuitar.frame.size.width*1.55, height: 100)
        PickerSelezione.frame = CGRect(x: 100, y: 200, width: 500, height: 150)
        
        
        fotoGuitar.frame = CGRect(x: 0, y: 0, width: 1200, height: 300)
        viewChitarra.frame = fotoGuitar.frame
        viewChitarra.addSubview(fotoGuitar)
        scrollViewGuitar.addSubview(viewChitarra)
        
        //  fotoGuitar.frame.size.height = 200
        //fotoGuitar.transform = CGAffineTransform.identity.rotated(by: CGFloat( +0.0))
        scrollViewGuitar.contentOffset = CGPoint(x: 300, y: 10)
        
        btn_back.frame = CGRect(x: 5, y: 5, width: 50, height: 50)
        btn_suona_accordo.frame = CGRect(x: PickerSelezione.frame.size.width+160, y: PickerSelezione.frame.size.height+70, width: 100, height: 100)
        btn_suona_accordo.backgroundColor = #colorLiteral(red: 1, green: 0.8270392501, blue: 0.04996715195, alpha: 0.8374090325)
        btn_suona_accordo.layer.cornerRadius = btn_suona_accordo.frame.size.height/2
        
        CreaManico()

         self.view.addSubview(scrollViewGuitar)
        
        controllaSchemiAccordi()
        
        MostraNotePresa(presa: 0)
        
       

        self.view.addSubview(btn_back)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func CreaManico(){
        
        
        for pippo in 0...5{
            var tag = 100
            for i in 0...arrPosizioniOrizzontali.count-1{
                if pippo == 0 { tag = 100}
                if pippo == 1 { tag = 200}
                if pippo == 2 { tag = 300}
                if pippo == 3 { tag = 400}
                if pippo == 4 { tag = 500}
                if pippo == 5 { tag = 600}
                xx -= arrPosizioniOrizzontali[i]
                
                var bottone = UIButton(frame: CGRect(x: xx, y: yy, width: 35, height:20))
                var lblbottone = UIButton(frame: CGRect(x: xx+27, y: yy-10, width: 14, height:14))
                lblbottone.titleLabel?.font = UIFont(name: "Courier", size: 9)
                
                bottone.titleLabel?.font = UIFont(name: "Courier", size: 14)
                bottone.tag = tag+i
                lblbottone.tag = tag+i+1000
                print(bottone.tag)
                bottone.layer.cornerRadius = 10
                lblbottone.layer.cornerRadius = 5
                bottone.backgroundColor = UIColor.purple
                lblbottone.backgroundColor = UIColor.white
                
                
                
                // mettiamo il titolo ad ogni nota creata
                bottone.setTitle(NoteRiempiManico[pippo][i], for: .normal)
                lblbottone.setTitle("1°", for: .normal)
                lblbottone.setTitleColor(UIColor.black, for: .normal)
                bottone.backgroundColor = UIColor.red
                
                bottone.isHidden = true
                lblbottone.isHidden = true
                viewChitarra.addSubview(bottone)
               viewChitarra.addSubview(lblbottone)
                print("LblBottone.tag",lblbottone.tag)
            }
            yy += 20
            xx = 880
        }
        
        
    }
    
    @IBAction func salvaAccordo(_ sender: Any) {
        accordoSalvato = []
        accordoSalvato.append(PickerSelezione.selectedRow(inComponent: 0))
        accordoSalvato.append(PickerSelezione.selectedRow(inComponent: 1))
        accordoSalvato.append(PickerSelezione.selectedRow(inComponent: 2))
        
    }
    
    @IBAction func mostraAccordoSalvato(_ sender: Any) {
        // li metto nella component
        if accordoSalvato.count != 0 {
        PickerSelezione.selectRow(accordoSalvato[0], inComponent: 0, animated: false)
        PickerSelezione.selectRow(accordoSalvato[1], inComponent: 1, animated: false)
        PickerSelezione.selectRow(accordoSalvato[2], inComponent: 2, animated: false)
    }
    }
    
    func RicavaAccordi(arrnTriadeAccordo:[Int]){
         AzzeraMonitorLabel()
        var  arrNomeNoteDellaScala: [String] = []
        
        for a in 0...arrnTriadeAccordo.count-1
        {
            if arrnTriadeAccordo[a] == 1{
                var StringApp = "Do"
                arrNomeNoteDellaScala.append(StringApp)
                
                
            }
            if arrnTriadeAccordo[a]  == 2{
                var StringApp = "Do#"
                arrNomeNoteDellaScala.append(StringApp)
                
            }
            if arrnTriadeAccordo[a]  == 3{
                var StringApp = "Re"
                arrNomeNoteDellaScala.append(StringApp)
                
                
                
            }
            if arrnTriadeAccordo[a]  == 4{
                var StringApp = "Re#"
                arrNomeNoteDellaScala.append(StringApp)
                
                
            }
            
            if arrnTriadeAccordo[a]  == 5{
                var StringApp = "Mi"
                arrNomeNoteDellaScala.append(StringApp)
                
            }
            if arrnTriadeAccordo[a]  == 6{
                var StringApp = "Fa"
                arrNomeNoteDellaScala.append(StringApp)
                
            }
            if arrnTriadeAccordo[a]  == 7{
                var StringApp = "Fa#"
                arrNomeNoteDellaScala.append(StringApp)
                
            }
            
            if arrnTriadeAccordo[a]  == 8{
                var StringApp = "Sol"
                arrNomeNoteDellaScala.append(StringApp)
                
                
            }
            if arrnTriadeAccordo[a]  == 9{
                var StringApp = "Sol#"
                arrNomeNoteDellaScala.append(StringApp)
            }
            if arrnTriadeAccordo[a]  == 10{
                var StringApp = "La"
                arrNomeNoteDellaScala.append(StringApp)
                
                
            }
            if arrnTriadeAccordo[a]  == 11{
                var StringApp = "La#"
                arrNomeNoteDellaScala.append(StringApp)
                
                
            }
            if arrnTriadeAccordo[a]  == 12{
                var StringApp = "Si"
                arrNomeNoteDellaScala.append(StringApp)
            }
        }
        print("arrNomeNoteDellaScala: ",arrNomeNoteDellaScala)
        for Pippo in 100...112{
            let a = view.viewWithTag(Pippo) as! UIButton
            let b = view.viewWithTag(Pippo+100) as! UIButton
            let c = view.viewWithTag(Pippo+200) as! UIButton
            let d = view.viewWithTag(Pippo+300) as! UIButton
            let e = view.viewWithTag(Pippo+400) as! UIButton
            let f = view.viewWithTag(Pippo+500) as! UIButton
            
            for pippoDue in 0...arrNomeNoteDellaScala.count-1{
                if a.titleLabel?.text == arrNomeNoteDellaScala[pippoDue]{
                    a.backgroundColor = UIColor.purple
                    a.isHidden = false
                    let tagBottone = a.tag+1000
                    let lblButton =  view.viewWithTag(tagBottone) as! UIButton
                    lblButton.isHidden = false
                    let NumConvertito = String(Int(pippoDue+1))
                    lblButton.setTitle(NumConvertito, for: .normal)
                }
                if b.titleLabel?.text == arrNomeNoteDellaScala[pippoDue]{
                    b.isHidden = false
                    b.backgroundColor = UIColor.purple
                    
                    let tagBottone = b.tag+1000
                    let lblButton =  view.viewWithTag(tagBottone) as! UIButton
                    lblButton.isHidden = false
                    let NumConvertito = String(Int(pippoDue+1))
                    lblButton.setTitle(NumConvertito, for: .normal)
                    
                }
                if c.titleLabel?.text == arrNomeNoteDellaScala[pippoDue]{
                    c.isHidden = false
                    c.backgroundColor = UIColor.purple
                    let tagBottone = c.tag+1000
                    let lblButton =  view.viewWithTag(tagBottone) as! UIButton
                    lblButton.isHidden = false
                    let NumConvertito = String(Int(pippoDue+1))
                    lblButton.setTitle(NumConvertito, for: .normal)
                    
                    
                }
                if d.titleLabel?.text == arrNomeNoteDellaScala[pippoDue]{
                    d.isHidden = false
                    d.backgroundColor = UIColor.purple
                    let tagBottone = d.tag+1000
                    let lblButton =  view.viewWithTag(tagBottone) as! UIButton
                    lblButton.isHidden = false
                    let NumConvertito = String(Int(pippoDue+1))
                    lblButton.setTitle(NumConvertito, for: .normal)
                    
                }
                if e.titleLabel?.text == arrNomeNoteDellaScala[pippoDue]{
                    e.isHidden = false
                    e.backgroundColor = UIColor.purple
                    let tagBottone = e.tag+1000
                    let lblButton =  view.viewWithTag(tagBottone) as! UIButton
                    lblButton.isHidden = false
                    let NumConvertito = String(Int(pippoDue+1))
                    lblButton.setTitle(NumConvertito, for: .normal)
                    
                }
                if f.titleLabel?.text == arrNomeNoteDellaScala[pippoDue]{
                    f.isHidden = false
                    f.backgroundColor = UIColor.purple
                    let tagBottone = f.tag+1000
                    let lblButton =  view.viewWithTag(tagBottone) as! UIButton
                    lblButton.isHidden = false
                    let NumConvertito = String(Int(pippoDue+1))
                    lblButton.setTitle(NumConvertito, for: .normal)
                    
                }
                
                
            }
            
            
            
            
            
        }
        
        
        
        
    }

   
    
    
    
    

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            
            return ArrNotePicker.count
        }
        if component == 1{
           return ArrTipoAccordo.count
        }
        if component == 2{
            return preseAccordi.count
        }
        return 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return ArrNotePicker[row]
        }
        if component == 1 {
            return ArrTipoAccordo[row]
        }
        if component == 2 {
            return "\(row+1)"
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
      

            controllaSchemiAccordi()
             MostraNotePresa(presa: 0)
        }
        if component == 1 {
           controllaSchemiAccordi()
             MostraNotePresa(presa: 0)

        }
        if component == 2 {
            MostraNotePresa(presa: row)
                   }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Bodoni 72", size: 25)
            pickerLabel?.textAlignment = .center
            pickerLabel?.textColor = UIColor.red
        }
        if component == 0 {
        pickerLabel?.text = ArrNotePicker[row]
        pickerLabel?.textColor = UIColor.black
            pickerLabel?.backgroundColor = #colorLiteral(red: 1, green: 0.2846451512, blue: 0.471349578, alpha: 0.5)
            pickerLabel?.layer.cornerRadius = 30
        }
        if component == 1 {
            pickerLabel?.text = ArrTipoAccordo[row]
            pickerLabel?.textColor = UIColor.black
            pickerLabel?.backgroundColor = #colorLiteral(red: 0.6234814293, green: 1, blue: 0.5399534333, alpha: 0.5)
            pickerLabel?.layer.cornerRadius = 30
        }
        if component == 2 {
            pickerLabel?.text = "\(row+1)"
            pickerLabel?.textColor = UIColor.black
            pickerLabel?.backgroundColor = #colorLiteral(red: 0.2072076432, green: 0.7431394195, blue: 0.9686274529, alpha: 0.5)
            pickerLabel?.layer.cornerRadius = 30
               }
        return pickerLabel!
    }
    
    
   
    //mostra i bottoni quando esiste la presa
    
    func MostraNotePresa(presa:Int){
        
        AzzeraMonitorLabel()
        // se no esistono prese facciamo return e usciamo dalla func senza fare nulla
        if preseAccordi.count == 0 {
            
            return
        }
        // creo arr vuoto in cui contiene le note che compongono un specifico schema di accordo.
          NoteDaSuonare.removeAll()
        var notePresa : [String] = []
        // mostro tutti i button della presa illuminandoli sulla tastiera
        for tag in preseAccordi[presa]{
            let bottone = view.viewWithTag(tag) as! UIButton
            bottone.isHidden = false
             notePresa.append((bottone.titleLabel?.text!)!)
            if  let suonoNota = Bundle.main.url(forResource: "\(tag)", withExtension: "m4a"){
                let playerNota = try! AVAudioPlayer(contentsOf: suonoNota)
                NoteDaSuonare.append(playerNota)
              
                
            }

        }
        let posizioneTonica = ArrNotePicker.index(of: notePresa[0])!
        var ArrNoteOrdinateInGradi : [String] = []
        // scorro dalla tonica fino alla fine della scala cromatica e verifico se la nota che compone l'accordo è presente e la inserisco in arrNoteOrdinateInGradi
        for i in posizioneTonica...ArrNotePicker.count-1{
            
            let nota = ArrNotePicker[i]
            if notePresa.contains(nota){
                ArrNoteOrdinateInGradi.append(nota)
                            }
            
        }
        // se non iniziamo dalla prima nota della scala cromatica allora prendiamo il resto delle note che compongono l'accordo
        if posizioneTonica != 0 {
            for i in 0...posizioneTonica-1{
                let nota = ArrNotePicker[i]
                if notePresa.contains(nota){
                    ArrNoteOrdinateInGradi.append(nota)
                }
            
            }
        
        }
        // ora prendiamo le posizioni delle note nell'array ordinato per inserire i bottoncini dei gradi ordinati
        
        for tag in preseAccordi[presa]{
            let bottone = view.viewWithTag(tag) as! UIButton
            let Nomenota = (bottone.titleLabel?.text!)!
            let grado = ArrNoteOrdinateInGradi.index(of: Nomenota)!+1
            let BottoneGrado = view.viewWithTag(tag+1000) as! UIButton
            BottoneGrado.isHidden = false
            BottoneGrado.setTitle("\(grado)", for: .normal)
            
        }

        
        
      //  var primeNote = Array(ArrNotePicker[posizioneTonica..<ArrNotePicker.count])
        //prendo una fetta di array
      //  let ultimeNote = Array(ArrNotePicker[0..<posizioneTonica])
        //var ArrayNoteOrdinateAccordo = primeNote.app
    }
    
    
    func AzzeraMonitorLabel(){
        for Pippo in 100...112{
            let a = view.viewWithTag(Pippo) as! UIButton
            let b = view.viewWithTag(Pippo+100) as! UIButton
            let c = view.viewWithTag(Pippo+200) as! UIButton
            let d = view.viewWithTag(Pippo+300) as! UIButton
            let e = view.viewWithTag(Pippo+400) as! UIButton
            let f = view.viewWithTag(Pippo+500) as! UIButton
            
            for pippoDue in 0...6{
                a.isHidden = true
                let AtagBottone = a.tag+1000
                let AlblButton =  view.viewWithTag(AtagBottone) as! UIButton
                AlblButton.isHidden = true
                
                b.isHidden = true
                let BtagBottone = b.tag+1000
                let BlblButton =  view.viewWithTag(BtagBottone) as! UIButton
                BlblButton.isHidden = true
                
                
                c.isHidden = true
                let CtagBottone = c.tag+1000
                let ClblButton =  view.viewWithTag(CtagBottone) as! UIButton
                ClblButton.isHidden = true
        
                
                d.isHidden = true
                let DtagBottone = d.tag+1000
                let DlblButton =  view.viewWithTag(DtagBottone) as! UIButton
                DlblButton.isHidden = true
                
                e.isHidden = true
                let EtagBottone = e.tag+1000
                let ElblButton =  view.viewWithTag(EtagBottone) as! UIButton
                ElblButton.isHidden = true
                
                
                f.isHidden = true
                let FtagBottone = f.tag+1000
                let FlblButton =  view.viewWithTag(FtagBottone) as! UIButton
                FlblButton.isHidden = true
                
                
                
                
            }
            
        }
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
     */
    func ruotaLblNote(){
       
        PickerSelezione.transform = PickerSelezione.transform.rotated(by: CGFloat.pi)
        btn_suona_accordo.transform = btn_suona_accordo.transform.rotated(by: CGFloat.pi)
        for Pippo in 100...112{
            let a = view.viewWithTag(Pippo) as! UIButton
            let b = view.viewWithTag(Pippo+100) as! UIButton
            let c = view.viewWithTag(Pippo+200) as! UIButton
            let d = view.viewWithTag(Pippo+300) as! UIButton
            let e = view.viewWithTag(Pippo+400) as! UIButton
            let f = view.viewWithTag(Pippo+500) as! UIButton
            
            for pippoDue in 0...6{
                a.transform = a.transform.rotated(by: CGFloat.pi)
                let AtagBottone = a.tag+1000
                let AlblButton =  view.viewWithTag(AtagBottone) as! UIButton
                AlblButton.transform = AlblButton.transform.rotated(by: CGFloat.pi)
                
                b.transform = b.transform.rotated(by: CGFloat.pi)
                let BtagBottone = b.tag+1000
                let BlblButton =  view.viewWithTag(BtagBottone) as! UIButton
                BlblButton.transform = BlblButton.transform.rotated(by: CGFloat.pi)
                
                c.transform = c.transform.rotated(by: CGFloat.pi)
                let CtagBottone = c.tag+1000
                let ClblButton =  view.viewWithTag(CtagBottone) as! UIButton
                ClblButton.transform = ClblButton.transform.rotated(by: CGFloat.pi)
                
                d.transform = d.transform.rotated(by: CGFloat.pi)
                let DtagBottone = d.tag+1000
                let DlblButton =  view.viewWithTag(DtagBottone) as! UIButton
                DlblButton.transform = DlblButton.transform.rotated(by: CGFloat.pi)
                
                e.transform = e.transform.rotated(by: CGFloat.pi)
                let EtagBottone = e.tag+1000
                let ElblButton =  view.viewWithTag(EtagBottone) as! UIButton
                ElblButton.transform = ElblButton.transform.rotated(by: CGFloat.pi)
                
                
                
               f.transform = f.transform.rotated(by: CGFloat.pi)
                let FtagBottone = f.tag+1000
                let FlblButton =  view.viewWithTag(FtagBottone) as! UIButton
                FlblButton.transform = FlblButton.transform.rotated(by: CGFloat.pi)
                
                if BoolLblRotazione == true {
                    
                    AlblButton.frame.origin.x = AlblButton.frame.origin.x + a.frame.size.width/6
                    AlblButton.frame.origin.y = AlblButton.frame.origin.y - a.frame.size.height/6
                    BlblButton.frame.origin.x = BlblButton.frame.origin.x + b.frame.size.width/6
                    BlblButton.frame.origin.y = BlblButton.frame.origin.y - b.frame.size.height/6
                    ClblButton.frame.origin.x = ClblButton.frame.origin.x + c.frame.size.width/6
                    ClblButton.frame.origin.y = ClblButton.frame.origin.y - c.frame.size.height/6
                    DlblButton.frame.origin.x = DlblButton.frame.origin.x + d.frame.size.width/6
                    DlblButton.frame.origin.y = DlblButton.frame.origin.y - d.frame.size.height/6
                    ElblButton.frame.origin.x = ElblButton.frame.origin.x + e.frame.size.width/6
                    ElblButton.frame.origin.y = ElblButton.frame.origin.y - e.frame.size.height/6
                    FlblButton.frame.origin.x = FlblButton.frame.origin.x + f.frame.size.width/6
                    FlblButton.frame.origin.y = FlblButton.frame.origin.y - f.frame.size.height/6

                    
                    
                    
                }
                else {
                    AlblButton.frame.origin.x = AlblButton.frame.origin.x  - a.frame.size.width/6
                    AlblButton.frame.origin.y = AlblButton.frame.origin.y + a.frame.size.height/6
                    BlblButton.frame.origin.x = BlblButton.frame.origin.x - b.frame.size.width/6
                    BlblButton.frame.origin.y = BlblButton.frame.origin.y + b.frame.size.height/6
                    ClblButton.frame.origin.x = ClblButton.frame.origin.x - c.frame.size.width/6
                    ClblButton.frame.origin.y = ClblButton.frame.origin.y + c.frame.size.height/6
                    DlblButton.frame.origin.x = DlblButton.frame.origin.x - d.frame.size.width/6
                    DlblButton.frame.origin.y = DlblButton.frame.origin.y + d.frame.size.height/6
                    ElblButton.frame.origin.x = ElblButton.frame.origin.x - e.frame.size.width/6
                    ElblButton.frame.origin.y = ElblButton.frame.origin.y + e.frame.size.height/6
                    FlblButton.frame.origin.x = FlblButton.frame.origin.x - f.frame.size.width/6
                    FlblButton.frame.origin.y = FlblButton.frame.origin.y + f.frame.size.height/6

                    
                    
                }
                
            }
            
        }
        
        
        
        BoolLblRotazione = !BoolLblRotazione // se è true diventa false e se false diventa true
        
    }
    
    
    // Funzione che mi calcola il numero di prese per ogni accordo selezionato nelle prime due component,la terza component mostra solo il numero di accoridie non richiamo la funzione.
    
    func controllaSchemiAccordi(){
        
        preseAccordi.removeAll()
    // prendiamo tutte le toniche
        
        // prendo l'indice nella component della nota selezionata
        let notaSelezionata = PickerSelezione.selectedRow(inComponent: 0)
        // vado a prendere la stringa della nota selezionato cioè il nome
        let nomeNota = ArrNotePicker[notaSelezionata]
        // stessa cosa per l'accordo prendo l'indice
        let accordoSelezionato = PickerSelezione.selectedRow(inComponent: 1)
        // prendo il nome
        let tipoAccordo = ArrTipoAccordo[accordoSelezionato]
      
        // salvo tutte le toniche sulla tastiera della chitarra cioè su ogni corda
        //
        var TagToniche : [Int] = []
        
        
        for Pippo in 100...112{
            let a = view.viewWithTag(Pippo) as! UIButton
            let b = view.viewWithTag(Pippo+100) as! UIButton
            let c = view.viewWithTag(Pippo+200) as! UIButton
            let d = view.viewWithTag(Pippo+300) as! UIButton
            let e = view.viewWithTag(Pippo+400) as! UIButton
            let f = view.viewWithTag(Pippo+500) as! UIButton
            // se mi trova la tonica per ogni corda faccio l'append e mi salvo tutte le toniche nella variable TagToniche
            if a.titleLabel?.text == nomeNota{
                TagToniche.append(a.tag)
            }
            if b.titleLabel?.text == nomeNota{
                TagToniche.append(b.tag)
            }
            if c.titleLabel?.text == nomeNota{
                TagToniche.append(c.tag)
            }
            if d.titleLabel?.text == nomeNota{
                TagToniche.append(d.tag)
            }
            if e.titleLabel?.text == nomeNota{
                TagToniche.append(e.tag)
            }
            if f.titleLabel?.text == nomeNota{
                TagToniche.append(f.tag)
            }

            
            
        }
      // ordiniamo per corda in ordine crescente
       TagToniche = TagToniche.sorted(by: {tonica1,tonica2 in
            return tonica1 < tonica2
        })
        // tagToniche abbiamo ordinato tutte le toniche per corda
// ora entriamo  nel tipo di accordo che ci interessa
        if tipoAccordo.lowercased() == "maggiore"{
            
            for tonica in TagToniche{
                for presa in Accordo_maggiore{
                    if abs(tonica-presa[0]) < 25{
                        var notePresaAccordo = CalcolaSommaArrayAccordo(presa: presa, tonica: tonica)
                        if notePresaAccordo.count != 0{
                            preseAccordi.append(notePresaAccordo)
                        }
                    }
                }
            }
        
        }
        else if tipoAccordo.lowercased() == "minore"{
            
            for tonica in TagToniche{
                for presa in Accordo_minore{
                    if abs(tonica-presa[0]) < 25{
                        var notePresaAccordo = CalcolaSommaArrayAccordo(presa: presa, tonica: tonica)
                        if notePresaAccordo.count != 0{
                            preseAccordi.append(notePresaAccordo)
                        }
                    }
                }
            }
            
        }
            else if tipoAccordo.lowercased() == "dim"{
                       
                       for tonica in TagToniche{
                           for presa in Accordo_dim{
                               if abs(tonica-presa[0]) < 25{
                                   var notePresaAccordo = CalcolaSommaArrayAccordo(presa: presa, tonica: tonica)
                                   if notePresaAccordo.count != 0{
                                       preseAccordi.append(notePresaAccordo)
                                   }
                               }
                           }
                       }
                       
                   }
            else if tipoAccordo.lowercased() == "aug"{
                       
                       for tonica in TagToniche{
                           for presa in Accordo_aug{
                               if abs(tonica-presa[0]) < 25{
                                   var notePresaAccordo = CalcolaSommaArrayAccordo(presa: presa, tonica: tonica)
                                   if notePresaAccordo.count != 0{
                                       preseAccordi.append(notePresaAccordo)
                                   }
                               }
                           }
                       }
                       
                   }
            else if tipoAccordo.lowercased() == "sus"{
                       
                       for tonica in TagToniche{
                           for presa in Accordo_sus{
                               if abs(tonica-presa[0]) < 25{
                                   var notePresaAccordo = CalcolaSommaArrayAccordo(presa: presa, tonica: tonica)
                                   if notePresaAccordo.count != 0{
                                       preseAccordi.append(notePresaAccordo)
                                   }
                               }
                           }
                       }
                       
                   }
           else if tipoAccordo.lowercased() == "6"{
               
               for tonica in TagToniche{
                   for presa in Accordo_6{
                       if abs(tonica-presa[0]) < 25{
                           var notePresaAccordo = CalcolaSommaArrayAccordo(presa: presa, tonica: tonica)
                           if notePresaAccordo.count != 0{
                               preseAccordi.append(notePresaAccordo)
                           }
                       }
                   }
               }
               
           }
        
      else if tipoAccordo.lowercased() == "7"{
          
          for tonica in TagToniche{
              for presa in Accordo_7{
                  if abs(tonica-presa[0]) < 25{
                      var notePresaAccordo = CalcolaSommaArrayAccordo(presa: presa, tonica: tonica)
                      if notePresaAccordo.count != 0{
                          preseAccordi.append(notePresaAccordo)
                      }
                  }
              }
          }
          
      }

        else if tipoAccordo.lowercased() == "maj7"{
            
            for tonica in TagToniche{
                for presa in Accordo_maj7{
                    if abs(tonica-presa[0]) < 25{
                        var notePresaAccordo = CalcolaSommaArrayAccordo(presa: presa, tonica: tonica)
                        if notePresaAccordo.count != 0{
                            preseAccordi.append(notePresaAccordo)
                        }
                    }
                }
            }
            
        }
        
        else if tipoAccordo.lowercased() == "9"{
            
            for tonica in TagToniche{
                for presa in Accordo_9{
                    if abs(tonica-presa[0]) < 25{
                        var notePresaAccordo = CalcolaSommaArrayAccordo(presa: presa, tonica: tonica)
                        if notePresaAccordo.count != 0{
                            preseAccordi.append(notePresaAccordo)
                        }
                    }
                }
            }
            
        }
        else if tipoAccordo.lowercased() == "add9"{
               
               for tonica in TagToniche{
                   for presa in Accordo_add9{
                       if abs(tonica-presa[0]) < 25{
                           var notePresaAccordo = CalcolaSommaArrayAccordo(presa: presa, tonica: tonica)
                           if notePresaAccordo.count != 0{
                               preseAccordi.append(notePresaAccordo)
                           }
                       }
                   }
               }
               
           }
        
        else if tipoAccordo.lowercased() == "m6"{
                      
                      for tonica in TagToniche{
                          for presa in Accordo_m6{
                              if abs(tonica-presa[0]) < 25{
                                  var notePresaAccordo = CalcolaSommaArrayAccordo(presa: presa, tonica: tonica)
                                  if notePresaAccordo.count != 0{
                                      preseAccordi.append(notePresaAccordo)
                                  }
                              }
                          }
                      }
                      
                  }
        else if tipoAccordo.lowercased() == "m7"{
                             
                             for tonica in TagToniche{
                                 for presa in Accordo_m7{
                                     if abs(tonica-presa[0]) < 25{
                                         var notePresaAccordo = CalcolaSommaArrayAccordo(presa: presa, tonica: tonica)
                                         if notePresaAccordo.count != 0{
                                             preseAccordi.append(notePresaAccordo)
                                         }
                                     }
                                 }
                             }
                             
                         }
        else if tipoAccordo.lowercased() == "mmaj7"{
                             
                             for tonica in TagToniche{
                                 for presa in Accordo_mmaj7{
                                     if abs(tonica-presa[0]) < 25{
                                         var notePresaAccordo = CalcolaSommaArrayAccordo(presa: presa, tonica: tonica)
                                         if notePresaAccordo.count != 0{
                                             preseAccordi.append(notePresaAccordo)
                                         }
                                     }
                                 }
                             }
                             
                         }
        else if tipoAccordo.lowercased() == "m9"{
            
            for tonica in TagToniche{
                for presa in Accordo_m9{
                    if abs(tonica-presa[0]) < 25{
                        var notePresaAccordo = CalcolaSommaArrayAccordo(presa: presa, tonica: tonica)
                        if notePresaAccordo.count != 0{
                            preseAccordi.append(notePresaAccordo)
                        }
                    }
                }
            }
            
        }
        else if tipoAccordo.lowercased() == "11"{
            
            for tonica in TagToniche{
                for presa in Accordo_11{
                    if abs(tonica-presa[0]) < 25{
                        var notePresaAccordo = CalcolaSommaArrayAccordo(presa: presa, tonica: tonica)
                        if notePresaAccordo.count != 0{
                            preseAccordi.append(notePresaAccordo)
                        }
                    }
                }
            }
            
        }
        else if tipoAccordo.lowercased() == "7sus4"{
            
            for tonica in TagToniche{
                for presa in Accordo_7sus4{
                    if abs(tonica-presa[0]) < 25{
                        var notePresaAccordo = CalcolaSommaArrayAccordo(presa: presa, tonica: tonica)
                        if notePresaAccordo.count != 0{
                            preseAccordi.append(notePresaAccordo)
                        }
                    }
                }
            }
            
        }
        else if tipoAccordo.lowercased() == "13"{
            
            for tonica in TagToniche{
                for presa in Accordo_13{
                    if abs(tonica-presa[0]) < 25{
                        var notePresaAccordo = CalcolaSommaArrayAccordo(presa: presa, tonica: tonica)
                        if notePresaAccordo.count != 0{
                            preseAccordi.append(notePresaAccordo)
                        }
                    }
                }
            }
            
        }
        else if tipoAccordo.lowercased() == "6add9"{
            
            for tonica in TagToniche{
                for presa in Accordo_6add9{
                    if abs(tonica-presa[0]) < 25{
                        var notePresaAccordo = CalcolaSommaArrayAccordo(presa: presa, tonica: tonica)
                        if notePresaAccordo.count != 0{
                            preseAccordi.append(notePresaAccordo)
                        }
                    }
                }
            }
            
        }
        else if tipoAccordo.lowercased() == "min5"{
            
            for tonica in TagToniche{
                for presa in Accordo_min5{
                    if abs(tonica-presa[0]) < 25{
                        var notePresaAccordo = CalcolaSommaArrayAccordo(presa: presa, tonica: tonica)
                        if notePresaAccordo.count != 0{
                            preseAccordi.append(notePresaAccordo)
                        }
                    }
                }
            }
            
        }
        else if tipoAccordo.lowercased() == "7min5"{
            
            for tonica in TagToniche{
                for presa in Accordo_7min5{
                    if abs(tonica-presa[0]) < 25{
                        var notePresaAccordo = CalcolaSommaArrayAccordo(presa: presa, tonica: tonica)
                        if notePresaAccordo.count != 0{
                            preseAccordi.append(notePresaAccordo)
                        }
                    }
                }
            }
            
        }

        else if tipoAccordo.lowercased() == "7maj5"{
            
            for tonica in TagToniche{
                for presa in Accordo_7maj5{
                    if abs(tonica-presa[0]) < 25{
                        var notePresaAccordo = CalcolaSommaArrayAccordo(presa: presa, tonica: tonica)
                        if notePresaAccordo.count != 0{
                            preseAccordi.append(notePresaAccordo)
                        }
                    }
                }
            }
            
        }
        else if tipoAccordo.lowercased() == "maj9"{
                   
                   for tonica in TagToniche{
                       for presa in Accordo_maj9{
                           if abs(tonica-presa[0]) < 25{
                               var notePresaAccordo = CalcolaSommaArrayAccordo(presa: presa, tonica: tonica)
                               if notePresaAccordo.count != 0{
                                   preseAccordi.append(notePresaAccordo)
                               }
                           }
                       }
                   }
                   
               }
        
        
        PickerSelezione.reloadComponent(2)
    
    }
    
    
    func CalcolaSommaArrayAccordo(presa:[Int],tonica:Int)->[Int] {
        
        var NotePresaAccordo : [Int] = [tonica]
        
        for i in 1...presa.count-1{
            let tagNota = tonica+presa[i]
              // verifichiamo se esiste il tag di quella nota
            if view.viewWithTag(tagNota) != nil {
                NotePresaAccordo.append(tagNota)
                
            }
            else{
                return []
            }
            
        }
        
        // facciamo il calcolo della presa max 4 tasti di distanza
        var posizioneTasti : [Int] = []
      
        // scorriamo tutti i tag aggiunti nell'array notePreseAccordo
        for tagNota in NotePresaAccordo{
            
           // prendiamo il valore del tag senza tenere in considerazione la corda
            // se non sono nel tasto 0 allora le controlliamo
            if tagNota % 100 != 0{
            posizioneTasti.append(tagNota%100)
            }
        }
        if posizioneTasti.count == 0 {
            return NotePresaAccordo
        }
        // se l'accordo non si riesce a comporre entro 3 capitasto viene annullato
        if posizioneTasti.max()! - posizioneTasti.min()! > 3{
            print("accordo impossibile")
            
            
            return []
        }
            var numero_note_sul_capotasto : [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
            for i in 0...posizioneTasti.count-1{
                print(i)
            let aaa : Int = posizioneTasti[i]
            let b = numero_note_sul_capotasto[aaa] + 1
           numero_note_sul_capotasto[aaa] = b
         
         
        }

        for i in 0...numero_note_sul_capotasto.count-1{
                
            
            if (numero_note_sul_capotasto[i] != 0 && numero_note_sul_capotasto[i+1] != 0 ) || (numero_note_sul_capotasto[i] != 0 && numero_note_sul_capotasto[i+2] != 0) {
                
               if  numero_note_sul_capotasto[i+1] > 3 {
                    print("accordo impossibile")
                return []
                }
                if  numero_note_sul_capotasto[i+2] > 3 {
                           print("accordo impossibile")
                       return []
                       }
           
            }
            
        }

        return NotePresaAccordo
    }
    
    

    @IBAction func Ruotalabel(_ sender: Any) {
        
        ruotaLblNote()
        
        
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return viewChitarra
    }
    
    
    @IBAction func BtnSuonaAccordo(_ sender: Any) {
        print("fuck")
        print(NoteDaSuonare)
        
        for nota in NoteDaSuonare{
            nota.currentTime = 0
            nota.play()
            print("fuck")
        }
        
    }
    
}
