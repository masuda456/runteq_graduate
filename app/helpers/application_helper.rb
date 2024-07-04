module ApplicationHelper
  def error_message_for(object, field)
    if object.errors[field].present?
      content_tag(:div, object.errors[field].join(", "), class: "text-danger")
    end
  end

  def default_meta_tags
    {
      site: 'OK Go Training',
      title: 'OK!合トレ!',
      reverse: true,
      charset: 'utf-8',
      description: '「別に一緒にやってもいいよ」という意思表示を互いに表明し合うことにより、トレーニングに誘う、誘われるハードルを下げることを目的としたサービスです。',
      canonical: request.original_url,
      separator: '|',
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('og-image.jpg'), # 配置するパスやファイル名によって変更すること
        local: 'ja-JP'
      },
      # Twitter用の設定を個別で設定する
      twitter: {
        card: 'summary_large_image', # Twitterで表示する場合は大きいカードにする
        site: '@RUNTEQ50aKoike', # アプリの公式Twitterアカウントがあれば、アカウント名を書く
        image: image_url('og-image.jpg') # 配置するパスやファイル名によって変更すること
      }
    }
  end
end
