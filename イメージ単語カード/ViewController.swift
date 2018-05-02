//
//  ViewController.swift
//  イメージ単語カード
//
//  Created by 青山聡一郎 on 2018/01/23.
//  Copyright © 2018年 S.Aoyama. All rights reserved.
//

import UIKit
import RealmSwift
import Photos


/// 単語一覧を表示する画面
/// 以下の機能を具備する。
/// ・Realmに格納された単語データをloadに初期化時に展開
/// ・絞り込み機能
/// ・新規登録画面へ遷移
/// ・単語表示画面へ遷移
/// ・削除機能
///
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    // TableView : 単語リスト
    @IBOutlet weak var wordList: UITableView!
    
    // 絞込みバー
    @IBOutlet weak var searchBarField: UISearchBar!
    
    // 単語key配列（マスタ）
    var wordsArray = [String]()
    // 単語key配列（表示用）
    var dispWordsArray = [String]()
    
    /// 初期化処理
    /// Realmから単語データを取得してTableViewに展開
    override func viewDidLoad() {
        
        // 最初にアクセス許可を出すためのおまじない
        // TODO 他にいい方法ないか調査
        //let assets: PHFetchResult =
            PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        // Realmを読み込み
        let realm = try! Realm()
        
        // 単語名で並び替え
        let savedWords = realm.self.objects(WordData.self).sorted(byKeyPath: "wordName", ascending: true)
        
        // 登録されているデータが存在する場合はtableViewに展開
        if savedWords.count != 0 {
            
            for word in savedWords {
                self.wordsArray.append(word.wordName)
            }
            
        }else{
            self.wordsArray = []
        }
        
        // 表示用の配列にコピー
        dispWordsArray = wordsArray;
        
        // TODO これの意味がいまいちわかってないので調査
        searchBarField.delegate = self;
        
        super.viewDidLoad()
    }

    
    /// メモリ不足時の処理
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// 新規作成画面へ遷移
    ///
    /// - Parameter sender : UIBarButtonItem(新規作成アイコン）
    @IBAction func newCreateButton(_ sender: Any) {
        let view = storyboard?.instantiateViewController(withIdentifier: "createNewWordController") as! CreateNewWordController
        present(view, animated: true, completion: nil);
    }
    
    
    /// テーブルに表示する配列の総数を取得する。
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - section: UITableViewのセクションindex
    /// - Returns: 表示する配列の総数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dispWordsArray.count
    }
    
    // callに値を設定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath)
        
        // セルに表示する値を設定する
        cell.textLabel!.text = dispWordsArray[indexPath.row]
        
        return cell
    }
    
    
    /// セル選択時
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - indexPath: <#indexPath description#>
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 表示画面を作成
        let view = storyboard?.instantiateViewController(withIdentifier: "dispWordController") as! DispWordController
        // キーを渡す
        view.keyWord = dispWordsArray[indexPath.row]
        view.dispWordsArray = dispWordsArray;
        
        // 遷移
        present(view, animated: true, completion: nil)
    }
    
    // スワイプして削除する
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // Realmからも削除
        let realm = try! Realm()
        
        print(dispWordsArray[indexPath.row])
        
        let delData = realm.object(ofType: WordData.self, forPrimaryKey: dispWordsArray[indexPath.row])
        
        try! realm.write {
            realm.delete(delData!)
        }
        
        if editingStyle == .delete {
            dispWordsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
    // serchbar押下時
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //表示用配列を初期化
        dispWordsArray = []
        
        //元の配列をループして検索条件と合致するか調べる
        for word in wordsArray {
            // 検索対象文字を含んでいれば表示用配列(漢字)に追加
            if word.range(of: searchBar.text!) != nil {
                dispWordsArray.append(word)
            }
            
        }
        
        //テーブル再表示
        wordList.reloadData()
    }
    
    // サーチバーのキャンセルボタンが押された時の処理
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // キャンセルボタンが押されたら全都道府県表示に戻る
        // サーチバーの中身を空にする
        searchBar.text = ""
        // キーボードをしまう
        searchBar.resignFirstResponder()
        // 表示用配列を元の配列と同じにする
        dispWordsArray = wordsArray
        // テーブル再表示
        wordList.reloadData()
    }
}

